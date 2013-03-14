class BoundingBox
  include MongoMapper::Document
  key :type, String, :required => true
  key :coordinates, Array, :required => true
  key :place_id, ObjectId
  belongs_to :place
  
  def self.example
    {"type"=>"Polygon", "coordinates"=>[[[4.7289, 52.278227], [5.079207, 52.278227], [5.079207, 52.431229], [4.7289, 52.431229]]]}
  end
  
  def self.new_from_raw(bounding_box, place_id)
    return nil if bounding_box.nil?
    bounding_box = Hashie::Mash[bounding_box]
    obj = self.new
    obj.type = bounding_box["type"]
    obj.coordinates = bounding_box["coordinates"]
    obj.place_id = place_id
    obj.save!
    obj
  end
end
