class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :bootstrap_flash

  private
  def nav(nav)
    @navs ||= []
    @navs << nav.to_s
  end
end
