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

Bundler.require(*Rails.groups)

module GwxRegistryApi
  class Application < Rails::Application
    config.load_defaults 5.2

    config.api_only = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.middleware.use ActionDispatch::Flash

    config.action_controller.allow_forgery_protection = false

    config.eager_load_paths << Rails.root.join('services')

    config.autoload_paths << Rails.root.join('services')
  end
end
