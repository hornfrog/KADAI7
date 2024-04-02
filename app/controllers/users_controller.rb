class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:edit, :update]
  def index
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(params.require(:user).permit(:email, :password, :password_confirmation))
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to user_path(@user)
    else
      render :edit
    end  
  end
end

private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation])
  end