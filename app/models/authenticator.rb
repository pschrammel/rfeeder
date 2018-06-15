class Authenticator
  include ActiveModel::Validations

  EXPECTED={
    issuer:"https://dev-auth.fixingthe.net",
    audience:"f3b7e5ad346926e70f4c5e8c853be3e6"
  }

  validate :extract

  attr_reader :token, :sub, :scopes
  def initialize(token:)
    @token=token
  end

  def expected
    EXPECTED
  end

  def expires_at
    Time.at(@expires_at)
  end
  def extract
    payload, info=JSON::JWT.decode token, :skip_verification
    config = ::OpenIDConnect::Discovery::Provider::Config.discover!(payload["iss"]) # cache this!
    public_key=config.jwks
    logger.debug [token,payload,info,config.inspect, public_key]
    decoded=::OpenIDConnect::ResponseObject::IdToken.decode(token, public_key)
    logger.debug [payload,info,config.inspect, public_key, decoded]

    errors.add("exp","expired") unless decoded.exp.to_i > Time.now.to_i
    errors.add("iss","wrong issuer") unless expected[:issuer]==decoded.iss
    #errors.add("nonce") ,expected[:nonce]==decoded.nonce
    errors.add("aud","wrong audience") unless Array(decoded.aud).include?(expected[:audience])
    begin
      decoded.verify!(expected.merge(nonce: decoded.nonce)) # nonce doesn't make sense
    rescue
      errors.add(:base, "verification failed!")
      logger.warn(["INVALID Token",$!])
    end
    @sub=decoded.sub
    @scopes=payload["scopes"]
    @expires_at=payload["exp"]
  end

  def logger
    Rails.logger
  end
end
