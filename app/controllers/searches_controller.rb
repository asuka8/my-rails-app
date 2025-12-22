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
end