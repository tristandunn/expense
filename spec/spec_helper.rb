ENV['RAILS_ENV'] ||= 'test'

unless defined?(RAILS_ROOT)
  require File.dirname(__FILE__) + '/../config/environment'
end

require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helpers')
