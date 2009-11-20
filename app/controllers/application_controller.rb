# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include Authentication

  # Include all helpers, all the time.
  helper :all

  # Require authentication by default.
  before_filter :login_required

  # Adjust the request form for iPhone requests.
  before_filter :adjust_format_for_iphone

  # See ActionController::RequestForgeryProtection for details.
  protect_from_forgery

  # Scrub sensitive parameters from your log.
  filter_parameter_logging :password, :password_confirmation

  protected

  def adjust_format_for_iphone
    request.format = :iphone if iphone_request?
  end

  def iphone_request?
    request.env['HTTP_USER_AGENT'] &&
      request.env['HTTP_USER_AGENT'][/(AppleWebKit.+Mobile)/]
  end
end
