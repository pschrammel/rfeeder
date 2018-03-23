module Api
  module V1
    class StoriesController < ApiController
      jsonapi resource: ::StoryResource

      def index
        scope=jsonapi_scope(Story
               .base(the_user).limit(10))

        so=scope.object
        #scope.resolve #(fire the requests)
        render_jsonapi(scope, #scope: false,
                       meta: {
                         page: {
                           total: so.total_pages,
                           current: so.current_page,
                           next: so.next_page,
                           prev: so.prev_page,
                           last: so.last_page?,
                           out_of_range: so.out_of_range?
                         },
                         count:  so.total_count
                       }
                      )
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

    end

  end
end
