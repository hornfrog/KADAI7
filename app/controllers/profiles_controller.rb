class ProfilesController < ApplicationController
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(params.require(:user).permit(:profile_image, :username, :profile))
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to user_profile_path(@user)
    else
      render :edit
    end  
  end



end
