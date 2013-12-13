class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :open]

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.includes(:feed).order('published DESC').all
    user_opens=UserOpen.for_stories(@stories,current_user).index_by(&:story_id)
    @stories.each do |story| story.user_open=user_opens[story.id] || UserOpen.missing(story,current_user) end

  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  def open
    Story.opened(@story,current_user)
    redirect_to @story.permalink
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end
end
