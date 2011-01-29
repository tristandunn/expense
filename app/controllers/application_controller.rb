class ApplicationController < ActionController::Base
  include Authentication

  before_filter :authenticate
  before_filter :adjust_format_for_iphone
  around_filter :adjust_time_zone, :if => :signed_in?

  protect_from_forgery

  protected

  def adjust_format_for_iphone
    user_agent = request.env['HTTP_USER_AGENT'].to_s

    if user_agent =~ /iPhone/
      request.format = :iphone
    end
  end

  def adjust_time_zone
    Time.zone = current_user.time_zone
    yield
  ensure
    Time.zone = "UTC"
  end
end
