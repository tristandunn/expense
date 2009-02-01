class UsersController < ApplicationController
  skip_before_filter :login_required,                     :only => [:new, :create]
  before_filter      :ensure_request_is_for_current_user, :only => [:delete, :destroy]

  # Display new user form.
  def new
    @user = User.new
  end

  # Attempt to create a user.
  #
  # If successful log the user in, otherwise display
  # the new user form.
  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user

      redirect_to '/'
    else
      render :action => 'new'
    end
  end

  # Display delete confirmation.
  def delete
  end

  # Destroy the current user.
  def destroy
    current_user.destroy

    redirect_to '/'
  end

  protected

  # Ensure the request is for the current user,
  # redirecting if not.
  def ensure_request_is_for_current_user
    redirect_to '/' unless current_user.id == params[:id].to_i
  end
end