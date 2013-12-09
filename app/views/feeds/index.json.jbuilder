json.array!(@feeds) do |feed|
  json.extract! feed, :id, :name, :url, :last_fetched_at, :feed_status_id
  json.url feed_url(feed, format: :json)
end
