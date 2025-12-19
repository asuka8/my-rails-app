class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # 自分の投稿でなければ保存する
    if @post.user != current_user
      @like = current_user.likes.create(post_id: @post.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = current_user.likes.find_by(post_id: @post.id)
    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end