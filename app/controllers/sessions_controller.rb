class SessionsController < ApplicationController
  skip_before_filter :authenticate

  def new
  end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    if signed_in?
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    reset_session

    redirect_to root_url
  end
end
