class StoriesController < ApplicationController
  before_action :set_story, :only => [:show, :open, :mark_read, :mark_read_later]

  # GET /stories
  # GET /stories.json
  # params page,
  def index
    logger.debug(params[:q].inspect)
    @q=StoryFilter.new(params[:q])

    @stories = Story.includes(:feed).order('published DESC').filter(@q, current_user).page(params[:page])

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
    now=(params[:before] ? Time.parse(params[:before]) : Time.now)

    Story.joins('LEFT OUTER JOIN user_opens ON stories.id = user_opens.story_id').where(['(user_opens.id is null OR user_opens.last_opened_at is NULL ) AND stories.created_at<?', now]).find_each do |story|
      UserOpen.story_of_user(story, current_user).open!
    end

    render :json => {:status => 'ok'}
  end

  #POST /stories/1/mark_read
  def mark_read
    opened=UserOpen.story_of_user(@story, current_user)
    if params[:toggle]
      opened.toggle_open!
    else
      opened.open!
    end

    render :json => {:opened => opened.opened?}
  end

  def mark_read_later
    opened=UserOpen.story_of_user(@story, current_user)
    if params[:toggle]
      opened.toggle_read_later!
    else
      opened.read_later!
    end

    render :json => {:read_later => opened.read_later?}
  end


  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  def open
    UserOpen.story_of_user(@story, current_user).open!
    redirect_to @story.permalink
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end
end
