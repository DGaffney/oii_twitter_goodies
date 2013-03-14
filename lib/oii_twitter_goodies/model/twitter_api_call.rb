class TwitterAPICall
  include MongoMapper::Document
  key :url, String
  key :data
  key :params
  timestamps!
end
