class Feed < ActiveRecord::Base
  has_many :stories, :dependent => :destroy
  belongs_to :status, :class_name => 'FeedStatus', :foreign_key => 'feed_status_id'

  def latest_entry_id
    stories.last.try(:entry_id)
  end

  def last_modified!(_last_modified)
    self.last_fetched_at=_last_modified
    save!
  end

  def status!(status_name)

  end
end
