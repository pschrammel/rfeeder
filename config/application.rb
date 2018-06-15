require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Rfeeder
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile << /application\-/
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.site_name='Rfeeder'
    config.domain_name='localhost:3000'
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end
    
#    Rails.application.config.middleware.use OmniAuth::Builder do
#
#      provider 'openid_connect', { 
#        scope: [:openid, :profile, :email],
#        response_type: :code,
#        discovery: true, 
#
#        client_options: {
#          port: ENV["OIC_PORT"] || '80',
#          scheme: ENV["OIC_SCHEME"] || 'https',
#          host: ENV["OIC_HOST"],
#          identifier: ENV["OIC_CLIENT_ID"],
#          secret: ENV["OIC_CLIENT_SECRET"],
#          redirect_uri: "#{ENV['OIC_CLIENT_URL']}/auth/openidconnect/callback",
#      }}
#    end
   
  end
end


AppConfig=Rfeeder::Application.config
