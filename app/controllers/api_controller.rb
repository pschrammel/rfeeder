class ApiController <  ActionController::Base
  include JsonapiSuite::ControllerMixin
  private
  def the_user
    @the_user ||= User.find(3)
  end
end
