class Size
  include MongoMapper::Document
  key :size, String
  key :resize, String
  key :h, Integer
  key :w, Integer
  key :media_id, ObjectId
  belongs_to :media
  
  def self.example
    {"thumb"=>{"resize"=>"crop", "h"=>150, "w"=>150}}
  end

  def self.new_from_raw(size_type, size_data, media_id)
    size_data = Hashie::Mash[size_data]
    obj = self.new
    obj.size   = size_type
    obj.resize = size_data["resize"]
    obj.h      = size_data["h"]
    obj.w      = size_data["w"]
    obj.media_id = media_id
    obj.save!
    obj
  end
end
