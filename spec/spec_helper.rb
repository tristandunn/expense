ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |file|
  require file
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = ::Rails.root.join('spec', 'fixtures')
  config.use_transactional_fixtures = true
end
