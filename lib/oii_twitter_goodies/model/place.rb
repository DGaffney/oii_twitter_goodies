require_relative 'place_attribute'
require_relative 'bounding_box'

class Place
  include MongoMapper::Document
  key :twitter_id, Integer
  key :url, String
  key :place_type, String
  key :name, String
  key :full_name, String
  key :country_code, String
  key :country, String
  key :bounding_box_id, ObjectId
  key :place_attribute_ids, Array
  many :place_attributes, :in => :place_attribute_ids
  key :tweet_id, ObjectId
  belongs_to :tweet
  belongs_to :bounding_box

  def self.example
    {"id"=>"99cdab25eddd6bce", "url"=>"http://api.twitter.com/1/geo/id/99cdab25eddd6bce.json", "place_type"=>"city", "name"=>"Amsterdam", "full_name"=>"Amsterdam, North Holland", "country_code"=>"NL", "country"=>"The Netherlands", "bounding_box"=>{"type"=>"Polygon", "coordinates"=>[[[4.7289, 52.278227], [5.079207, 52.278227], [5.079207, 52.431229], [4.7289, 52.431229]]]}, "attributes"=>{}}
  end
    
  def self.new_from_raw(place, tweet_id)
    return if place.nil?
    place = Hashie::Mash[place]
    obj = self.new
    obj.twitter_id   = place["twitter_id"]
    obj.url          = place["url"]
    obj.place_type   = place["place_type"]
    obj.name         = place["name"]
    obj.full_name    = place["full_name"]
    obj.country_code = place["country_code"]
    obj.country      = place["country"]
    bounding_box = BoundingBox.new_from_raw(place["bounding_box"].attrs, obj._id)
    if bounding_box
      obj.bounding_box = bounding_box
    end
    
    place["attributes"].each_pair do |key, value|
      place = PlaceAttribute.new_from_raw(key, value, obj._id)
      obj.place_attributes << place
    end
    obj.tweet_id = tweet_id
    obj.save!
    obj
  end
end