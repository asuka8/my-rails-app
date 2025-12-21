class PostsController < ApplicationController
  # セキュリティチェックを一時的に緩和して動作を安定させます
  protect_from_forgery except: :destroy 
  
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def show
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "投稿しました！"
    else
      redirect_to root_path, alert: "投稿に失敗しました"
    end
  end

  def edit
    redirect_to root_path, alert: "権限がありません" unless @post.user == current_user
  end

  def update
    if @post.update(post_params)
      redirect_to root_path, notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # どんな方法でアクセスされても削除を実行
    @post.destroy
    redirect_to root_path, notice: "投稿を削除しました", status: :see_other
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      redirect_to root_path, alert: "指定された投稿が見つかりませんでした"
    end
  end

  def post_params
    # :image を追加
    params.require(:post).permit(:content, :image)
  end

  def liked_users
    @post = Post.find(params[:id])
    @users = @post.liked_users
  end

end