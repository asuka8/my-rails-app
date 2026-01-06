class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # 投稿一覧（タイムラインはHomeコントローラーで処理している場合は不要なこともありますが、定義しておきます）
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # 投稿詳細
  def show
  end

  # 新規投稿作成
  def create
    @post = Post.new(content: post_params[:content])
    @post.user_id = current_user.id

    if @post.save
      if params[:post][:images].present?
        # 一つずつ丁寧にアタッチする
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
  # 編集画面
  def edit
    # 自分の投稿以外は編集できないようにセキュリティをかける
    redirect_to root_path, alert: "権限がありません。" unless @post.user == current_user
  end

  # 更新処理
  def update
    if @post.update(content: post_params[:content])
      # 画像を新しく追加する場合
      if params[:post][:images].present?
        clean_images = params[:post][:images].reject(&:blank?)
        @post.images.attach(clean_images) if clean_images.any?
      end
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @post.destroy if @post.user == current_user
    redirect_to root_path, notice: "投稿を削除しました"
  end

  private

  private

  def set_post
    # IDがハッシュ形式 {id: "27"} で送られてきても、数値 "27" で送られてきても対応する
    post_id = params[:id].is_a?(Hash) ? params[:id][:id] : params[:id]
    
    @post = Post.find_by(id: post_id)
    
    if @post.nil?
      redirect_to root_path, alert: "その投稿は存在しないか、既に削除されています。"
    end
  end

  def search
    raise "ここまで処理が届いています！" # これを追記
    # 1. フォームから送られてきたキーワードを取得
    @keyword = params[:keyword]

    if @keyword.present?
      # 2. 投稿内容を検索（ここで SQL が発行されるはずです）
      @posts = Post.where("content LIKE ?", "%#{@keyword}%").order(created_at: :desc)
      
      # 3. ついでにユーザー名も検索
      @users = User.where("nickname LIKE ?", "%#{@keyword}%")
    else
      @posts = Post.none
      @users = User.none
    end
  end
  # ストロングパラメータ
  def post_params
    # images: [] として配列を許可
    params.require(:post).permit(:content, images: [])
  end
end