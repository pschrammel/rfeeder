class UserOpen < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  def self.opened(story, user)
    uo=where(["story_id=? AND user_id=?", story.id, user.id]).first || new(:story => story, :user => user)
    uo.last_opened_at=Time.now
    uo.save
  end
  scope :for_stories, lambda { |stories,user|
    where(:user_id => user.id).where(['story_id in (?)',stories.map(&:id)])
  }

  def self.missing(story, user)
    new(:story => story, :user => user)
  end

  def seen?
    !!last_opened_at
  end

end
