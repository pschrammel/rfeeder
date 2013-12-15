require 'thread/pool'

class FetchFeeds
  def initialize(feeds, logger=Rails.logger, pool = Thread.pool(10))
    @feeds = feeds
    @pool = pool
    @logger = logger
  end

  def fetch_all
    @feeds.each do |feed|
      @pool.process do
        FeedFetcher.new(feed, @logger).fetch
        @logger.info "FEED #{feed.name}: done"
        #ActiveRecord::Base.connection.close #why?
      end
    end

    @pool.shutdown
    @logger.info "POOL SHUTDOWN"
  end

  def self.enqueue(feeds)
    self.new(feeds).fetch_all
  end
end
