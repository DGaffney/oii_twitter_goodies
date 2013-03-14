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
      data = Hashie::Mash[@client.send(direction+"_ids", screen_name, :cursor => cursor).attrs]
      ids = ids|data.ids
      cursor = data["next_cursor"]
    end
    return ids
  end
  
  def user_data_for(screen_names)
    screen_names = [screen_names].flatten
    user_data = []
    screen_names.each_slice(100) do |screen_name_set|
      user_data = [user_data|@client.users(screen_name_set)].flatten
    end
    user_data
  end
end