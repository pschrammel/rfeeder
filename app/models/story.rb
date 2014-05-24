class Story < ActiveRecord::Base
  belongs_to :feed
  validates_uniqueness_of :entry_id, :scope => :feed_id

  attr_accessor :user_open

  def self.create_from_raw(feed, entry)
    #might fail!
    Story.create(:feed => feed,
                 :title => entry.title,
                 :permalink => entry.url,
                 :raw_body => entry,
                 :is_read => false,
                 :is_starred => false,
                 :published => entry.published || Time.now,
                 :entry_id => entry.id)

  end

  scope :filter, lambda { |filter, user|

    if filter.read_later?
      sc=joins("LEFT JOIN user_opens ON stories.id=user_opens.story_id").where(["user_opens.user_id=?", user.id])
      sc=sc.where("user_opens.read_later_at is not null")
      sc
    end
  }

  def headline
    self.title.nil? ? UNTITLED : strip_html(self.title)[0, 100]
  end

  def lead
    strip_html(self.body)[0, 600]
  end

  def source
    self.feed.name
  end

  def pretty_date
    I18n.l(self.published)
  end

  def seen_text
    user_open.opened? ? I18n.l(user_open.last_opened_at) : 'new'
  end

  def raw_body=(entry)
    self.body=extract_content(entry)
  end

  private


  #perhaps move this to an extractor
  def extract_content(entry)
    sanitized_content = ""

    if entry.content
      sanitized_content = sanitize(entry.content)
    elsif entry.summary
      sanitized_content = sanitize(entry.summary)
    end

    expand_absolute_urls(sanitized_content, entry.url)
  end

  def sanitize(content)
    Loofah.fragment(content.gsub(/<wbr>/i, "")).scrub!(:prune).to_s
  end

  def expand_absolute_urls(content, base_url)
    doc = Nokogiri::HTML.fragment(content)
    abs_re = URI::DEFAULT_PARSER.regexp[:ABS_URI]

    [["a", "href"], ["img", "src"], ["video", "src"]].each do |tag, attr|
      doc.css("#{tag}[#{attr}]").each do |node|
        url = node.get_attribute(attr)
        unless url =~ abs_re
          node.set_attribute(attr, URI.join(base_url, url).to_s)
        end
      end
    end

    doc.to_html
  end

  def strip_html(contents)
    Loofah.fragment(contents).text
  end
end