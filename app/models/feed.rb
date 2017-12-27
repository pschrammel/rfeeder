# == Schema Information
#
# Table name: feeds
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  url             :text             not null
#  last_fetched_at :datetime
#  feed_status_id  :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

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
