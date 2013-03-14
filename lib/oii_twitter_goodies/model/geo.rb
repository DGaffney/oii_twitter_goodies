class Geo
  include MongoMapper::Document
  key :type, String
  #coordinate coordinates are lon lat - geo coordinates are lat lon.
  key :coordinates, Array
  key :tweet_id, ObjectId
  belongs_to :tweet
  
  def self.example
    {"type"=>"Point", "coordinates"=>[52.37051453, 4.8930892]}
  end
  
  def self.new_from_raw(geo, tweet_id)
    return if geo.nil?
    geo = Hashie::Mash[geo]
    obj = self.new
    obj.type = geo["type"]
    obj.coordinates = geo["coordinates"]
    obj.tweet_id = tweet_id
    obj.save!
    obj
  end
end