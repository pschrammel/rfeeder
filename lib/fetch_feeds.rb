require 'thread/pool'

class FetchFeeds
  def initialize(feeds, pool = Thread.pool(10))
    @feeds = feeds
    @pool = pool
  end

  def fetch_all
    @feeds.each do |feed|
      @pool.process do
        FeedFetcher.new(feed).fetch

        ActiveRecord::Base.connection.close
      end
    end

    @pool.shutdown
  end

  def self.enqueue(feeds)
    self.new(feeds).fetch_all
  end
end
