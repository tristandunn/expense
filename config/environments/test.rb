config.whiny_nils = true
config.cache_classes = true
config.action_mailer.delivery_method = :test
config.action_controller.perform_caching             = false
config.action_controller.allow_forgery_protection    = false
config.action_controller.consider_all_requests_local = true

config.gem 'rspec',       :lib => false, :version => '>= 1.3.0'
config.gem 'rspec-rails', :lib => false, :version => '>= 1.3.2'
config.gem 'timecop',                    :version => '>= 0.3.4'

config.after_initialize do
  Timecop.freeze(Time.local(2009, 7, 1, 12))
end
