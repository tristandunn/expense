class ApplicationController < ActionController::Base
  include Authentication

  layout 'application'

  before_filter :login_required
  before_filter :adjust_format_for_iphone

  protect_from_forgery

  protected

  def adjust_format_for_iphone
    request.format = :iphone if iphone_request?
  end

  def iphone_request?
    request.env['HTTP_USER_AGENT'] &&
      request.env['HTTP_USER_AGENT'][/(AppleWebKit.+Mobile)/]
  end
end
