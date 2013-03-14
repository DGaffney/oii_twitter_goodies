class Egonet
  include MongoMapper::Document
  key :alter_ids, Array
  key :ego_id, Integer
  key :alter_user_ids, Array
  key :user_id, ObjectId
  belongs_to :user
end