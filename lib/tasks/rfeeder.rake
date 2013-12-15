require 'fetch_feeds'

namespace :rfeeder do
  desc "import"
  task :import => [:environment] do
    Feed.find_in_batches do |feeds|
      logger=Logger.new(Rails.root.join('log/import.log'))
      FetchFeeds.new(feeds, logger).fetch_all
    end
  end
end
