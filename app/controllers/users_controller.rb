class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all # 全ユーザーを取得
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :profile_image)
  end
end