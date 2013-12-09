class FeedFetcher

  USER_AGENT = "WebKit"

  def initialize(feed, feed_parser = Feedzirra::Feed, logger = Rails.logger)
    @feed = feed
    @parser = feed_parser
    @logger = logger
  end

  def fetch
    begin
      raw_feed = @parser.fetch_and_parse(@feed.url,
                                         :user_agent => USER_AGENT,
                                         :if_modified_since => @feed.last_fetched_at,
                                         :timeout => 30,
                                         :max_redirects => 2)

      if raw_feed == 304
        @logger.info "#{@feed.url} has not been modified since last fetch"
      else
        new_entries_from(raw_feed).each do |entry|
          Story.create_from_raw(@feed,entry)
        end

        @feed.last_modified!(raw_feed.last_modified)
      end

      @feed.status!(:green)
    rescue Exception => ex
      @feed.status!(:red)
      @logger.error "Something went wrong when parsing #{@feed.url}: #{ex},#{ex.backtrace.join("\n")}"
    end
  end

  private
  def new_entries_from(raw_feed)
    finder = NewStoriesFinder.new(raw_feed, @feed.last_fetched_at, @feed.latest_entry_id)
    finder.new_stories
  end

end