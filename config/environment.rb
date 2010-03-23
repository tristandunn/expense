# Be sure to restart your server when you modify this file

RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone   = 'Eastern Time (US & Canada)'
  config.frameworks -= [:active_resource, :action_mailer]
end
