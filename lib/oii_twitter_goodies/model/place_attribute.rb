class PlaceAttribute
  include MongoMapper::Document
  key :name, String
  key :value, String
  key :place_id, ObjectId
  belongs_to :place

  def self.example
    {"street_address"=>"5403 Stevens Creek Blvd"}
  end
  
  def self.new_from_raw(key, value, place_id)
    obj = self.new
    obj.name = key
    obj.value = value
    obj.place_id = place_id
    obj.save!
    obj
  end
end