class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  # --- 検索機能を private の外（上）に移動しました ---
  def search
    @keyword = params[:keyword].to_s.strip
    @posts = Post.none
    @users = User.none

    if @keyword.present?
      search_word = @keyword.unicode_normalize(:nfkc).downcase

      # 全件取得してRuby側でマッチング（確実な方法）
      found_posts = Post.all.select do |post|
        post.content.to_s.unicode_normalize(:nfkc).downcase.include?(search_word)
      end
      
      found_users = User.all.select do |user|
        user.nickname.to_s.unicode_normalize(:nfkc).downcase.include?(search_word)
      end

      @posts = Post.where(id: found_posts.map(&:id)).order(created_at: :desc)
      @users = User.where(id: found_users.map(&:id))
    end
  end

  def create
    @post = Post.new(content: post_params[:content])
    @post.user_id = current_user.id

    if @post.save
      if params[:post][:images].present?
        params[:post][:images].each do |image|
          @post.images.attach(image) if image.present?
        end
      end
      redirect_to root_path, notice: "投稿が完了しました！"
    else
      @posts = Post.all.order(created_at: :desc)
      render "home/index", status: :unprocessable_entity
    end
  end

  def edit
    redirect_to root_path, alert: "権限がありません。" unless @post.user == current_user
  end

  def update
    if @post.update(content: post_params[:content])
      if params[:post][:images].present?
        clean_images = params[:post][:images].reject(&:blank?)
        @post.images.attach(clean_images) if clean_images.any?
      end
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy if @post.user == current_user
    redirect_to root_path, notice: "投稿を削除しました"
  end

  # --- ここから下はクラス内部でのみ使うメソッド ---
  private

  def set_post
    post_id = params[:id].is_a?(Hash) ? params[:id][:id] : params[:id]
    @post = Post.find_by(id: post_id)
    
    if @post.nil?
      redirect_to root_path, alert: "その投稿は存在しないか、既に削除されています。"
    end
  end

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end