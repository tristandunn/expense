require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Expense
  class Application < Rails::Application
    config.encoding  = 'UTF-8'
    config.time_zone = 'UTC'

    config.filter_parameters += [:password, :password_confirmation]
  end
end
