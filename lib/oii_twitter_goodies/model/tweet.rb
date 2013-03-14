require_relative 'user_mention'
require_relative 'coordinate'
require_relative 'hashtag'
require_relative 'media'
require_relative 'place'
require_relative 'geo'
require_relative 'url'

class Tweet
  include MongoMapper::Document
  key :created_at, Time, :required => true
  key :twitter_id, Integer, :required => true
  key :twitter_id_str, String, :required => true
  key :text, String, :required => true
  key :source, String, :required => true
  key :truncated, Boolean, :default => false, :required => true
  key :in_reply_to_status_id, Integer
  key :in_reply_to_status_id_str, String
  key :in_reply_to_user_id, Integer
  key :in_reply_to_user_id_str, String
  key :in_reply_to_screen_name, String
  key :contributors, Array, :default => []
  key :retweet_count, Integer, :default => 0, :required => true
  key :favorited, Boolean, :default => false, :required => true
  key :retweeted, Boolean, :default => false, :required => true
  key :possibly_sensitive, Boolean, :default => false, :required => true
  key :geo_id, ObjectId
  key :coordinate_id, ObjectId
  key :place_id, ObjectId
  key :user_id, ObjectId
  key :hashtag_ids, Array
  key :url_ids, Array
  key :user_mention_ids, Array
  key :media_ids, Array
  many :hashtags, :in => :hashtag_ids
  many :urls, :in => :url_ids
  many :user_mentions, :in => :user_mention_ids
  many :media, :in => :media_ids
  key :user_id, ObjectId
  belongs_to :geo
  belongs_to :coordinate
  belongs_to :place
  belongs_to :user

  def self.example
    {"entities"=>{"user_mentions"=>[], "urls"=>[{"display_url"=>"tehelka.com/story_main54.a...", "expanded_url"=>"http://www.tehelka.com/story_main54.asp?filename=Ws041212SPORTS.asp", "url"=>"http://t.co/uZmKgdkO", "indices"=>[120, 140]}], "hashtags"=>[]}, "text"=>"On the day Indian Olympics Association was suspended by IOC, Rahul Mehra says the move gives an opportunity to clean up http://t.co/uZmKgdkO", "retweet_count"=>2, "coordinates"=>nil, "possibly_sensitive"=>false, "in_reply_to_status_id_str"=>nil, "contributors"=>nil, "in_reply_to_user_id_str"=>nil, "id_str"=>"276035961274638336", "in_reply_to_screen_name"=>nil, "retweeted"=>false, "truncated"=>false, "created_at"=>"Tue Dec 04 18:51:16 +0000 2012", "geo"=>nil, "place"=>nil, "in_reply_to_status_id"=>nil, "favorited"=>false, "source"=>"web", "id"=>276035961274638336, "in_reply_to_user_id"=>nil}
  end

  def self.new_from_raw(tweet, user_id)
    return if tweet.nil?
    tweet = Hashie::Mash[tweet]
    obj = self.new
    obj.created_at                = tweet["created_at"]
    obj.twitter_id                = tweet["id"]
    obj.twitter_id_str            = tweet["id_str"]
    obj.text                      = tweet["text"]
    obj.source                    = tweet["source"]
    obj.truncated                 = tweet["truncated"]
    obj.in_reply_to_status_id     = tweet["in_reply_to_status_id"]
    obj.in_reply_to_status_id_str = tweet["in_reply_to_status_id_str"]
    obj.in_reply_to_user_id       = tweet["in_reply_to_user_id"]
    obj.in_reply_to_user_id_str   = tweet["in_reply_to_user_id_str"]
    obj.in_reply_to_screen_name   = tweet["in_reply_to_screen_name"]
    obj.contributors              = tweet["contributors"]
    obj.retweet_count             = tweet["retweet_count"]
    obj.favorited                 = tweet["favorited"]
    obj.retweeted                 = tweet["retweeted"]
    obj.possibly_sensitive        = tweet["possibly_sensitive"]
    tweet["twitter_id"]           = obj.twitter_id
    if tweet["entities"]
      tweet["entities"].each_pair do |entity_type, entities|
        if entity_type == "media"
          entities.each do |entity|
            entity = Medium.new_from_raw(entity, obj._id)
            obj.media << entity
          end
        elsif entity_type == "urls"
          entities.each do |entity|
            entity = Url.new_from_raw(entity, obj._id)
            obj.urls << entity
          end
        elsif entity_type == "hashtags"
          entities.each do |entity|
            entity = Hashtag.new_from_raw(entity, obj._id)
            obj.hashtags << entity
          end
        elsif entity_type == "user_mentions"
          entities.each do |entity|
            entity = UserMention.new_from_raw(entity, obj._id)
            obj.user_mentions << entity
          end
        end
      end
    end
    place = Place.new_from_raw(tweet["place"].attrs, obj._id)
    if place
      obj.place = place
    end
    geo = Geo.new_from_raw(tweet["geo"].attrs, obj._id)
    if geo
      obj.geo = geo
    end
    coordinate = Coordinate.new_from_raw(tweet["coordinate"].attrs, obj._id)
    if coordinate
      obj.coordinate = coordinate
    end
    obj.user_id = user_id
    obj.save!
    obj
  end  
  
end