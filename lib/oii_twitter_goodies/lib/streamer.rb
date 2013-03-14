class Streamer
  attr_accessor :stream_type, :stream_conditions, :oauth_token, :oauth_token_secret, :consumer_key, :consumer_secret

  def initialize(opts={})
    opts = Hashie::Mash[opts]
    @stream_type = opts[:stream_type] || "track"
    @stream_conditions = opts[:stream_conditions] || "lol"
    @oauth_token = opts[:oauth_token]
    @oauth_token_secret = opts[:oauth_token_secret]
    @consumer_key = opts[:consumer_key]
    @consumer_secret = opts[:consumer_secret]
    TweetStream.configure do |config|
      config.consumer_key = @consumer_key
      config.consumer_secret = @consumer_secret
      config.oauth_token = @oauth_token
      config.oauth_token_secret = @oauth_token_secret
    end
    @client = TweetStream::Client.new
    self.send("prepare_#{@stream_type}_variables")
  end
  
  def prepare_follow_variables
    raise "Stream Conditions can't be nil!" if @stream_conditions.nil?
    raise "Stream Conditions must be a comma-separated string or array!" if ![String, Array].include?(@stream_conditions.class)
    @stream_conditions = @stream_conditions.split(",") if @stream_conditions.class == String
    sc_count = @stream_conditions.count
    @stream_conditions = @stream_conditions.collect(&:to_i)
    @stream_conditions = @stream_conditions.select{|sc| sc != 0}
    raise "#{sc_count-@stream_conditions.length} values were dropped from stream conditions as they were not integers. You must specify integers (representing valid user IDs on Twitter) for this to work" if sc_count != @stream_conditions.length
    raise "Stream conditions are empty!" if @stream_conditions.length == 0
    @stream_conditions
  end
  
  def prepare_track_variables
    raise "Stream Conditions can't be nil!" if @stream_conditions.nil?
    raise "Stream Conditions must be a comma-separated string or array!" if ![String, Array].include?(@stream_conditions.class)
    raise "Stream conditions are empty!" if @stream_conditions.length == 0
    @stream_conditions = @stream_conditions.split(",") if @stream_conditions.class == String
    @stream_conditions
  end
  
  def prepare_locations_variables
    new_value = []
    @stream_conditions.split(",").each_slice(4) do |lat_lon_pair|
      boundings = lat_lon_pair.collect{|b| b.to_f}
      raise "Must input two pairs of numbers, separated by commas." if boundings.length!=4
      raise "Latitudes are out of range (max 90 degrees)" if boundings[1].abs>90 || boundings[3].abs>90
      raise "Longitudes are out of range (max 180 degrees)" if boundings[0].abs>180 || boundings[2].abs>180
      new_value << boundings
    end
    @stream_conditions = new_value.flatten.collect(&:to_f )
    
  end
  
  def stream(&block)
    EM.run do
      @client.on_error {|msg| puts msg }
      @client.on_limit {|skip_count| puts "limit reached: #{skip_count} skipped"}
      @client.send(@stream_type, @stream_conditions) do |status|
        block.call status
      end
    end
  end
end