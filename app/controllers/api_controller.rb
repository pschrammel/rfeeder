class ApiController <  ActionController::Base
  include JsonapiSuite::ControllerMixin
  before_action :authenticate!
  private
  def the_user
    @the_user ||= User.find(3)
  end

  EXPECTED_AUDIENCE="f3b7e5ad346926e70f4c5e8c853be3e6"
  EXPECTED_ISSUER="https://dev-auth.fixingthe.net"

  def authenticate!
    logger.info "headers: #{request.headers["Authorization"]}"
    auth=request.headers["Authorization"]
    if auth && match=auth.match(/Bearer (.*)/)
      id_token=match[1]
      auth=Authenticator.new(token: match[1])
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
      logger.info("no authentification sent")
      render_401
    end
  end

  def render_401
    render json: { json_api: { version: 1.0},
                   errors: [{status: 401, title: "Authentication needed"}]}, status: 401
  end
end
