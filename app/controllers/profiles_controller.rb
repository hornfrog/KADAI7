class ProfilesController < ApplicationController
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profiles_params)
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to :profile_path
    else
      render :edit
    end  
  end

  private

 def profiles_params
  params.require(:profile).permit(:name, :profile)
 end

end
