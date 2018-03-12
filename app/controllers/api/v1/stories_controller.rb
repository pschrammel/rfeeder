module Api
  module V1
    class StoriesController < ApiController
      jsonapi resource: ::StoryResource

      def index
        scope=Story
               .base(the_user)
               .limit(10)
               .all
        render_jsonapi(scope)
      end


      def update
        story, success = jsonapi_update.to_a

        if success
          render_jsonapi(story, scope: false)
        else
          render_errors_for(story)
        end
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
