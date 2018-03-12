class StoryResource < ApplicationResource
  type :stories
  model Story
  default_sort [{id: :desc}]

  allow_filter :unopened do |scope, value|
    scope.where('last_opened_at is null')
  end

  allow_filter :marked do |scope, value|
    scope.where('read_later_at is not null')
  end

  def update(attributes)
    user=User.find(3)
    story =Story.base(user).find(attributes.delete(:id))
    Rails.logger.debug(attributes)
    if attributes.key?(:last_opened_at)
      if attributes[:last_opened_at]
        set=Time.now
      else
        set=nil
      end
      with_opened(story,user) do |opened|
        opened.last_opened_at=
          story.last_opened_at=set
      end
    end
    if attributes.key?(:read_later_at)
      if attributes[:read_later_at]
        set=Time.now
      else
        set=nil
      end
      with_opened(story,user) do |opened|
        opened.read_later_at=
          story.read_later_at=set
      end
    end
    story
  end

  private

  def with_opened(story,user)
    opened=UserOpen.story_of_user(story, user)
    yield opened
    opened.save!
  end
end
