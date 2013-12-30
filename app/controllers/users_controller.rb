class UsersController < ApplicationController
  before_action      :ensure_request_is_for_current_user, only: [:delete, :destroy]
  skip_before_action :authenticate,                       only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_parameters)

    if @user.save
      self.current_user = @user

      redirect_to root_url
    else
      render :new
    end
  end

  def update
    current_user.update_attributes(user_parameters)

    redirect_to root_url
  end

  def delete
    render :delete
  end

  def destroy
    current_user.destroy

    redirect_to root_url
  end

  protected

  def ensure_request_is_for_current_user
    redirect_to(root_url) unless current_user.id == params[:id].to_i
  end

  def user_parameters
    params.require(:user).permit(:email, :password, :password_confirmation, :time_zone)
  end
end
