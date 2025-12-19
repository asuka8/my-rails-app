class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all # 全ユーザーを取得
  end

  def show
    # IDが数字ではない（sign_outなど）場合は、処理を中断してホームへ飛ばす
    if params[:id] == "sign_out" || params[:id].to_i == 0 && params[:id] != "0"
      redirect_to root_path and return
    end

    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
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