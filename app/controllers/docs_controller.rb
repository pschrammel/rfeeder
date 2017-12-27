require 'jsonapi_swagger_helpers'

JsonapiSpecHelpers::Payload.register(:story) do
  key(:title, String)
  timestamps!
end

class DocsController < ActionController::API
  include JsonapiSwaggerHelpers::DocsControllerMixin
  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'RSS-feeder'
      key :description, 'desc'
      contact do
        key :name, 'contact_name'
        key :email, 'contact_email'
      end
    end
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  jsonapi_resource '/v1/stories', only: [:index]
end
