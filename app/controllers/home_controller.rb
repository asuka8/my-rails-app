class HomeController < ApplicationController
  def index
    if user_signed_in?
      @post = Post.new
      
      if params[:filter] == "all"
        # 「おすすめ」：全ユーザーの投稿
        @posts = Post.all.order(created_at: :desc)
      else
        # 「フォロー中」：自分とフォローしている人の投稿（デフォルト）
        following_ids = current_user.following.pluck(:id)
        @posts = Post.where(user_id: following_ids << current_user.id).order(created_at: :desc)
      end
    end
  end
end