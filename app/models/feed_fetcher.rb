class FeedFetcher

  USER_AGENT = "WebKit"

  def initialize(feed, logger = Rails.logger, feed_parser = Feedzirra::Feed )
    @feed = feed
    @parser = feed_parser
    @logger = logger
    @failed=0
    @stories=0
    @succeeded=0
  end

  def fetch
    begin
      @logger.info "FEED #{@feed.name}: fetching from #{@feed.url}"
      raw_feed = @parser.fetch_and_parse(@feed.url,
                                         :user_agent => USER_AGENT,
                                         :if_modified_since => @feed.last_fetched_at,
                                         :timeout => 30,
                                         :max_redirects => 2)

      if raw_feed == 304
        @logger.info "FEED #{@feed.name}: has not been modified since last fetch"
      else
        new_entries_from(raw_feed).each do |entry|
          @stories += 1
          if Story.create_from_raw(@feed,entry)
            @succeeded += 1
          else
            @failed += 1
          end
        end
        @feed.last_modified!(raw_feed.last_modified)
      end
      @feed.status!(:green)
    rescue Exception => ex
      @logger.error "FEED #{@feed.name}: something went wrong when parsing #{@feed.url}: #{ex},#{ex.backtrace.join("\n")}"
      @feed.status!(:red)
    end
    @logger.info "FEED #{@feed.name}: done (new: #{@stories} | ok: #{@succeeded} | fail: #{@failed})"
  end

  private
  def new_entries_from(raw_feed)
    finder = NewStoriesFinder.new(raw_feed, @feed.last_fetched_at, @feed.latest_entry_id)
    finder.new_stories
  end

end