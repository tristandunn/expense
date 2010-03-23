class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
  end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    if logged_in?
      redirect_to '/'
    else
      render :new
    end
  end

  def destroy
    reset_session

    redirect_to '/'
  end
end
