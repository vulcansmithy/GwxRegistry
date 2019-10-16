require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
require "sprockets/railtie"
require 'aws-sdk-secretsmanager'

Bundler.require(*Rails.groups)

module GwxRegistryApi
  class Application < Rails::Application
    config.load_defaults 5.2

    config.api_only = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end

    config.middleware.use ActionDispatch::Flash

    config.action_controller.allow_forgery_protection = false

    config.eager_load_paths << Rails.root.join('services')

    config.autoload_paths << Rails.root.join('services')
    config.autoload_paths << Rails.root.join('app', 'forms')
    config.autoload_paths << Rails.root.join('lib')

    if Rails.env.development? || Rails.env.test?
      config.before_configuration do
        env_file = File.join(Rails.root, 'config', "local_env.#{Rails.env}.yml")
        if File.exist?(env_file)
          YAML.safe_load(File.open(env_file)).each do |key, value|
            ENV[key.to_s] = value
          end
        end
      end
    elsif Rails.env.staging? || Rails.env.production?
      config.before_configuration do
        region = 'ap-southeast-1'
        secrets_prefix = "registry_api_#{Rails.env}"
        client = Aws::SecretsManager::Client.new(
          region: region
        )
      
        secrets = JSON.parse client.get_secret_value(secret_id: secrets_prefix).secret_string
      
        secrets.each do |key, value|
          ENV[key] = value
          puts "Loading ENV Variable '#{key}' from AWS Secrets"
        end
      end
    end
  end
end
