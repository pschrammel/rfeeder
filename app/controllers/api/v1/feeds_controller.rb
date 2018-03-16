module Api
  module V1
    class FeedsController < ApiController
      jsonapi resource: ::FeedResource

      def index
        scope=Feed
        render_jsonapi(scope)
      end


      def update
        feed, success = jsonapi_update.to_a
        if success
          render_jsonapi(feed, scope: false)
        else
          render_errors_for(feed)
        end
      end

      # def show
      #   scope = jsonapi_scope(Story.where(id: params[:id]))
      #   render_jsonapi(scope.resolve.first, scope: false)
      # end

    end

  end
end
