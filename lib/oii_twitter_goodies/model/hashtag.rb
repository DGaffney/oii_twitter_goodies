class Hashtag
  include MongoMapper::Document
  key :text, String
  key :indices, Array
  key :tweet_id, ObjectId
  belongs_to :tweet
  
  def self.example
    {"text"=>"IDMA", "indices"=>[27, 32]}
  end
  
  def self.new_from_raw(entity, tweet_id)
    entity = Hashie::Mash[entity]
    obj         = self.new
    obj.text    = entity["text"]
    obj.indices = entity["indices"]
    obj.tweet_id = tweet_id
    obj.save!
    obj
  end
end