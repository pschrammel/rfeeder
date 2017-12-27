class SerializableStory < JSONAPI::Serializable::Resource
  type :stories
  attribute :title
  attribute :created_at
  attribute :updated_at
end
