class StoryResource < ApplicationResource
  type :stories
  model Story
  default_sort [{id: :desc}]
  def update(attributes)
    story =Story.find(attributes.delete(:id))
    Rails.logger.debug(attributes)
    #post.update_attributes(attributes)
    story
  end
end
