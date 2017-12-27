class StoryResource < ApplicationResource

  type :stories
  model Story
  default_sort [{id: :desc}]

end
