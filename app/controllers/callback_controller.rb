class CallbackController < ApplicationController
  def index
     @env=request.env
     p @auth_info=@env['omniauth.auth']
     p @auth_info.uid
     p @auth_info.info.email
     p @auth_info.credentials.id_token
     p @auth_info.credentials.token
#     redirect_to "https://#{ENV["FRONTEND_AUTH_CALLBACK_URL"]}?"
  end
end
