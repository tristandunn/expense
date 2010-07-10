class UsersController < ApplicationController
  skip_before_filter :authenticate,
                     :only => [:new, :create]
  before_filter      :ensure_request_is_for_current_user,
                     :only => [:delete, :destroy]

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

  def delete
  end

  def destroy
    current_user.destroy

    redirect_to root_url
  end

  protected

  def ensure_request_is_for_current_user
    redirect_to root_url unless current_user.id == params[:id].to_i
  end
end
