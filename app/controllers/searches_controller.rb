class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @results = User.where("nickname LIKE ? OR email LIKE ?", "%#{@word}%", "%#{@word}%")
    else
      # 投稿の検索結果も .order(created_at: :desc) で最新順にする
      @results = Post.where("content LIKE ?", "%#{@word}%").order(created_at: :desc)
    end
  end

  def autocomplete
    @word = params[:word]
    # 入力された文字に一致するユーザー名と、投稿内容の一部を取得
    users = User.where("nickname LIKE ?", "%#{@word}%").limit(5).pluck(:nickname)
    posts = Post.where("content LIKE ?", "%#{@word}%").limit(5).pluck(:content)
    
    # 投稿内容は長い場合があるので、20文字で切り取る
    results = users + posts.map { |p| p.truncate(20) }
    
    render json: results.uniq
  end
end