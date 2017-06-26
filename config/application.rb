require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Santa
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # SMTP Settings
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true

    config.action_mailer.default_url_options = { :host => ENV['default_url_host'] }
    config.action_mailer.asset_host = ENV['default_url_host']

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address => ENV['smtp_host'],
        :port => ENV['smtp_port'].to_i,
        :domain => ENV['smtp_domain'],
        :user_name => ENV['smtp_username'],
        :password => ENV['smtp_password'],
        :authentication => ENV['smtp_authentication'],
        :enable_starttls_auto => true # ENV['smtp_enable_starttls_auto']
    }
  end
end
