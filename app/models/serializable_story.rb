class SerializableStory < JSONAPI::Serializable::Resource
  type :stories
  attribute :created_at
  attribute :updated_at

  attribute :headline
  attribute :lead
  attribute :source
  attribute :permalink
end
