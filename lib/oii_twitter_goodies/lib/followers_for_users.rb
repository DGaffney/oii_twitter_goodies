class FollowersForUsers

  attr_accessor :screen_names, :oauth_token, :oauth_token_secret, :consumer_key, :consumer_secret, :client

  def initialize(opts={})
    opts = Hashie::Mash[opts]
    @screen_names = opts[:screen_names] || []
    @oauth_token = opts[:oauth_token]
    @oauth_token_secret = opts[:oauth_token_secret]
    @consumer_key = opts[:consumer_key]
    @consumer_secret = opts[:consumer_secret]
    @screen_names = [@screen_names].flatten
    Twitter.configure do |config|
      config.consumer_key = @consumer_key
      config.consumer_secret = @consumer_secret
      config.oauth_token = @oauth_token
      config.oauth_token_secret = @oauth_token_secret
    end
    @client = Twitter::Client.new
  end
  
  def grab_followers
    results = {}
    @screen_names.each do |screen_name|
      puts "Current progress: #{@screen_names.index(screen_name)}/#{@screen_names.length} started"
      user = user_data_for(screen_name)
      follower_ids = follower_ids_for(screen_name)
      user_data = user_data_for(follower_ids)
      results[user.first.attrs] = user_data
      puts "Current progress: ##{@screen_names.index(screen_name)}/#{@screen_names.length} complete"      
    end
    puts "Done!"
    return results
  end
    
  def follower_ids_for(screen_name)
    return direction_ids_for screen_name, "follower"
  end

  def friend_ids_for(screen_name)
    return direction_ids_for screen_name, "friend"
  end

  def direction_ids_for(screen_name, direction)
    cursor = -1
    ids = []
    while cursor != 0
      puts cursor
      begin
        data = Hashie::Mash[@client.send(direction+"_ids", screen_name, :cursor => cursor).attrs]
      rescue Twitter::Error::BadGateway
        puts "Got Twitter::Error::BadGateway error - usually this is just a missed connect from Twitter."
        sleep(10)
        retry
      rescue Twitter::Error::TooManyRequests
        puts "Got Twitter::Error::TooManyRequests error - we are rate limited and will sleep for 15 minutes. See you in a bit."
        sleep(15*60)
        retry
      end
      ids = ids|data.ids
      cursor = data["next_cursor"]
    end
    return ids
  end
  
  def user_data_for(screen_names)
    screen_names = [screen_names].flatten
    user_data = []
    screen_names.each_slice(100) do |screen_name_set|
      begin
        user_data = [user_data|@client.users(screen_name_set)].flatten
      rescue Twitter::Error::BadGateway
        puts "Got Twitter::Error::BadGateway error - usually this is just a missed connect from Twitter."
        sleep(10)
        retry
      rescue Twitter::Error::TooManyRequests
        puts "Got Twitter::Error::TooManyRequests error - we are rate limited and will sleep for 15 minutes. See you in a bit."
        sleep(15*60)
        retry
      end
    end
    user_data
  end
end