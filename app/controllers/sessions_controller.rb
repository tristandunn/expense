class SessionsController < ApplicationController
  skip_before_filter :login_required

  # Display new session form.
  def new
  end

  # Attempt to authenticate user. If invalid, display
  # new session form.
  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    if logged_in?
      redirect_to '/'
    else
      render :action => 'new'
    end
  end

  # Destroy the current session.
  def destroy
    reset_session

    redirect_to '/'
  end
end