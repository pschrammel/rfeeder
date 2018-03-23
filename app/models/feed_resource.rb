class FeedResource < ApplicationResource
  type :feeds
  model Feed
  default_sort [{name: :asc}]

end
