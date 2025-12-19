class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォローするとき
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    # 処理が終わったら、元のページ（ユーザー詳細画面など）に戻す
    redirect_back(fallback_location: root_path, notice: "#{@user.nickname || @user.email}さんをフォローしました")
  end

  # フォロー解除するとき
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    # 処理が終わったら、元のページに戻す
    redirect_back(fallback_location: root_path, notice: "フォローを解除しました")
  end
end