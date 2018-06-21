class StoryResource < ApplicationResource
  type :stories
  model Story
  default_sort [{id: :desc}]

  allow_filter :unopened do |scope, value|
    scope.where('last_opened_at is null')
  end

  allow_filter :unmarked do |scope, value|
    scope.where('read_later_at is null')
  end

  allow_filter :marked do |scope, value|
    scope.where('read_later_at is not null')
  end

  def update(attributes)
    story =Story.base(the_user).find(attributes.delete(:id))
    if attributes.key?(:last_opened_at)
      if attributes[:last_opened_at]
        set=Time.now
      else
        set=nil
      end
      with_opened(story) do |opened|
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
      with_opened(story) do |opened|
        opened.read_later_at=
          story.read_later_at=set
      end
    end
    story
  end

  private

  def the_user
    @the_user ||= context.send(:the_user)
  end

  def with_opened(story)
    opened=UserOpen.story_of_user(story, the_user)
    yield opened
    opened.save!
  end
end
