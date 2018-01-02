class SerializableStory < JSONAPI::Serializable::Resource
  type :stories

  attribute :created_at
  attribute :updated_at

  attribute :headline
  attribute :lead
  attribute :source
  attribute :permalink

  # from user_opens
  attribute :last_opened_at
  attribute :read_later_at
end
