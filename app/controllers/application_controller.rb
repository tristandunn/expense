# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include Authentication

  # Include all helpers, all the time.
  helper :all

  # Require authentication by default.
  before_filter :login_required

  # See ActionController::RequestForgeryProtection for details.
  protect_from_forgery

  # Scrub sensitive parameters from your log.
  filter_parameter_logging :password, :password_confirmation
end