class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :open, :mark_read]

  # GET /stories
  # GET /stories.json
  # params page,
  def index
    @stories = Story.includes(:feed).order('published DESC').page(params[:page])
    user_opens=UserOpen.for_stories(@stories, current_user).index_by(&:story_id)
    @stories.each do |story|
      story.user_open=user_opens[story.id] || UserOpen.missing(story, current_user)
    end
    render :partial => 'index' if params[:partial]
  end

  #POST /stories/mark_all_read
  #mark all stories read by me that are currently in the system
  #TODO: in a special selection
  def mark_all_read
    #TODO: this should be a background job:
    now=Time.now

    Story.joins('LEFT OUTER JOIN user_opens ON stories.id = user_opens.story_id').where(['user_opens.id is null AND created_at<?', now]).find_each do |story|
      Story.opened(story, current_user)
    end

    render :json => {:status => 'ok'}
  end

  #POST /stories/1/mark_read
  def mark_read
    Story.opened(@story, current_user)
    render :json => {:status => 'ok'}
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  def open
    Story.opened(@story, current_user)
    redirect_to @story.permalink
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end
end
