class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to post_path(@post), notice: "返信を投稿しました"
    else
      redirect_to post_path(@post), alert: "返信に失敗しました（空欄は不可です）"
    end
  end

  def edit
    # 自分のコメント以外は編集不可
    redirect_to post_path(@post) unless @comment.user == current_user
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: "返信を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy if @comment.user == current_user
    redirect_to post_path(@post), notice: "返信を削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end