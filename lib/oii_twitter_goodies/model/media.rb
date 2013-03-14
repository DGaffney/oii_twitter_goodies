require_relative 'size'

class Medium
  include MongoMapper::Document
  key :display_url, String
  key :media_url, String
  key :id_str, String
  key :media_url_https, String
  key :expanded_url, String
  key :url, String
  key :type, String
  key :id, Integer
  key :indices, Array
  key :size_ids, Array
  many :sizes, :in => :size_ids
  key :tweet_id, ObjectId
  belongs_to :tweet
  
  def self.example
    {"display_url"=>"pic.twitter.com/I8kPMVvy", "media_url"=>"http://pbs.twimg.com/media/A9TiOUSCYAArxdM.jpg", "sizes"=>{"thumb"=>{"resize"=>"crop", "h"=>150, "w"=>150}, "large"=>{"resize"=>"fit", "h"=>230, "w"=>632}, "small"=>{"resize"=>"fit", "h"=>124, "w"=>340}, "medium"=>{"resize"=>"fit", "h"=>218, "w"=>600}}, "id_str"=>"276094212766851072", "media_url_https"=>"https://pbs.twimg.com/media/A9TiOUSCYAArxdM.jpg", "expanded_url"=>"http://twitter.com/insomniacevents/status/276094212758462465/photo/1", "url"=>"http://t.co/I8kPMVvy", "type"=>"photo", "id"=>276094212766851072, "indices"=>[118, 138]}
  end

  def self.new_from_raw(media, tweet_id)
    media = Hashie::Mash[media]
    obj = self.new
    obj.display_url     = media["display_url"]
    obj.media_url       = media["media_url"]
    obj.id_str          = media["id_str"]
    obj.media_url_https = media["media_url_https"]
    obj.expanded_url    = media["expanded_url"]
    obj.url             = media["url"]
    obj.type            = media["type"]
    obj.id              = media["id"]
    obj.indices         = media["indices"]
    media["sizes"].each_pair do |size_type, size_data|
      size = Size.new_from_raw(size_type, size_data, obj._id)
      obj.sizes << size
    end
    obj.tweet_id = tweet_id
    obj.save!
    obj
  end
end