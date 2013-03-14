class Url
  include MongoMapper::Document
  key :url, String
  key :expanded_url, String
  key :display_url, String
  key :indices, Array
  key :tweet_id, ObjectId
  belongs_to :tweet
  
  def self.example
    {"display_url"=>"bit.ly/SKHqYj", "expanded_url"=>"http://bit.ly/SKHqYj", "url"=>"http://t.co/ZDfXBGCk", "indices"=>[97, 117]}
  end
  
  def self.new_from_raw(url, tweet_id)
    url = Hashie::Mash[url]
    obj = self.new
    obj.url          = url["url"]
    obj.expanded_url = url["expanded_url"]
    obj.display_url  = url["display_url"]
    obj.indices      = url["indices"]
    obj.tweet_id     = tweet_id
    obj.save!
    obj
  end
end