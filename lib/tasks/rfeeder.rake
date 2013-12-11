require 'fetch_feeds'

namespace :rfeeder do
  desc "import"
  task :import => [:environment] do
    Feed.find_in_batches do |feeds|
      FetchFeeds.new(feeds).fetch_all
    end
  end
end
