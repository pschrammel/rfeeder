class ApiController <  ActionController::Base
  include JsonapiSuite::ControllerMixin
  before_action :authenticate!
  private
  def the_user
    @the_user ||= User.find(3)
  end

  def authenticate!
    logger.info "headers: #{request.headers["Authorization"]}"
    auth=Authenticator.parse(request.headers["Authorization"])
    unless auth.guest?
      if auth.valid?
        logger.info(["valid authentification:", auth.sub,
                     auth.scopes,
                     auth.expires_at])

      else
        logger.info(["invalid authentification",
                     auth.errors,
                     auth.scopes,
                     auth.expires_at
                    ])
        render_401
      end
    else
      logger.info("no authentification sent/guest")
      render_401
    end
  end

  def render_401
    render json: { json_api: { version: 1.0},
                   errors: [{status: 401, title: "Authentication needed"}]}, status: 401
  end
end
