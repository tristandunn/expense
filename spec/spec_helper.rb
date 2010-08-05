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

  def user_is_valid
    controller.stub!(:current_user).and_return(@user = mock_model(User))
  end
end

RSpec::Matchers.define :assign_to do |key, expected|
  match do
    assigns(key).should == expected
  end

  failure_message_for_should do
    "expected #{expected.inspect} to be assigned to @#{key}"
  end

  failure_message_for_should_not do
    "expected #{expected.inspect} to not be assigned to @#{key}"
  end
end
