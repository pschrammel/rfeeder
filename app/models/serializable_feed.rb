class SerializableFeed < JSONAPI::Serializable::Resource
  type :feeds

  attribute :created_at
  attribute :updated_at

  attribute :name
  attribute :url
  attribute :last_fetched_at


  #meta do
  #  { featured: true }
  #end
end
