class Coordinate
  include MongoMapper::Document
  key :type, String
  #coordinate coordinates are lon lat - geo coordinates are lat lon.
  key :coordinates, Array
  key :tweet_id, ObjectId
  belongs_to :tweet
  
  def self.example
    {"type"=>"Point", "coordinates"=>[4.8930892, 52.37051453]}
  end
  
  def self.new_from_raw(coordinate, tweet_id)
    return if coordinate.nil?
    coordinate = Hashie::Mash[coordinate]
    obj = self.new
    obj.type = coordinate["type"]
    obj.coordinates = coordinate["coordinates"]
    obj.tweet_id = tweet_id
    obj.save!
    obj
  end
end