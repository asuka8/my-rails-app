class PostsController < ApplicationController
  #protect_from_forgery except: :destroy 
  
  before_action :authenticate_user!
  # show, edit, update, destroy, liked_users の5つで @post を準備するように設定
  before_action :set_post, only: [:show, :edit, :update, :destroy, :liked_users]

  def show
    # 詳細画面ではコメントも表示するため、@post は set_post で取得済み
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
    @post.destroy
    redirect_to root_path, notice: "投稿を削除しました", status: :see_other
  end

  # --- ここが重要：いいねした人一覧 ---
  def liked_users
    @users = @post.liked_users
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      redirect_to root_path, alert: "指定された投稿が見つかりませんでした"
    end
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end