module Api
  module V1
    class StoriesController < ApiController
      jsonapi resource: ::StoryResource

      def index
        render_jsonapi(Story.includes(:feed).all)
      end

      # def show
      #   scope = jsonapi_scope(Story.where(id: params[:id]))
      #   render_jsonapi(scope.resolve.first, scope: false)
      # end

    end
  end
end
