class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    if @post.user != current_user
      @like = current_user.likes.create(post_id: @post.id)
      
      # 通知の作成
      unless Notification.exists?(visitor_id: current_user.id, visited_id: @post.user_id, post_id: @post.id, action: 'like')
        notification = current_user.active_notifications.new(
          post_id: @post.id,
          visited_id: @post.user_id,
          action: 'like'
        )
        notification.save if notification.valid?
      end
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