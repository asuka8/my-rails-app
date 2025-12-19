class HomeController < ApplicationController
  def index
    if user_signed_in?
      @post = Post.new
      # 全員の投稿ではなく、ログインユーザーのフィードを取得
      @posts = current_user.feed
    else
      @posts = Post.none # ログインしていない場合は空にする
    end
  end
end