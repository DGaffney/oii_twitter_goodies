class Edge
  include MongoMapper::Document
  key :source
  key :target
  key :edge_type
  key :metadata
  key :ended_at
  timestamps!
end
