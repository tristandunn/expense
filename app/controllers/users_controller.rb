class UsersController < ApplicationController
  before_filter      :ensure_request_is_for_current_user, only: [:delete, :destroy]
  skip_before_filter :authenticate,                       only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user

      redirect_to root_url
    else
      render :new
    end
  end

  def update
    current_user.update_attributes(params[:user])

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
end
