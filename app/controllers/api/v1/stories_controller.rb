module Api
  module V1
    class StoriesController < ApiController
      jsonapi resource: ::StoryResource

      def index
        scope=Story
               .includes(:feed)
               .select('stories.*, user_opens.last_opened_at as last_opened_at, user_opens.read_later_at as read_later_at')
               .order("id desc")
               .limit(10)
               .left_outer_joins(:user_opens).
               where(["user_opens.user_id=? or user_opens.user_id is null",the_user.id]).all
        render_jsonapi(scope)
      end

      # def show
      #   scope = jsonapi_scope(Story.where(id: params[:id]))
      #   render_jsonapi(scope.resolve.first, scope: false)
      # end
      private
      def the_user
        @the_user ||= User.find(3)
      end
    end

  end
end
