class UsersController < ApplicationController
  skip_before_filter :login_required,
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

      redirect_to '/'
    else
      render :new
    end
  end

  def delete
  end

  def destroy
    current_user.destroy

    redirect_to '/'
  end

  protected

  def ensure_request_is_for_current_user
    redirect_to '/' unless current_user.id == params[:id].to_i
  end
end
