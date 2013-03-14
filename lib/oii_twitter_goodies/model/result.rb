class Result
  include MongoMapper::Document
  key :type, String, :required => true, :default => "export_processes"
  key :data
  key :user_id, ObjectId
  belongs_to :user
end
# Result.ensure_index([[:user_id, 1], [:type, 1]], :unique => true)