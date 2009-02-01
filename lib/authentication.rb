module Authentication
  protected

  # Automatically add helper methods when included.
  def self.included(base)
    if base.respond_to?(:helper_method)
      base.send(:helper_method, :current_user, :logged_in?)
    end
  end

  # Redirect when authentication fails, or overwrite in a controller.
  def access_denied
    redirect_to new_session_url
  end

  # Load the user using the ID in the session variable, if present.
  def user_from_session
    self.current_user = User.find(session[:user]) if session[:user]
  end

  # Return the current user, attempting to find it if needed. If not
  # found, set it to +:false+ to prevent future database hits.
  def current_user
    @current_user ||= (user_from_session || :false)
  end

  # If given a +User+, store it and set the session variable, otherwise
  # set both to +nil+.
  def current_user=(user)
    @current_user  = user.is_a?(User) ? user    : nil
    session[:user] = user.is_a?(User) ? user.id : nil
  end

  # Determine if the user is logged in.
  def logged_in?
    current_user != :false
  end

  # Filter method to enfore a login requirement.
  def login_required
    access_denied unless logged_in?
  end
end