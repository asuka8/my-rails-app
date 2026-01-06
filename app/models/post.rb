class Post < ApplicationRecord
  # ユーザーとの紐付け
  belongs_to :user

  # 【最重要】ここを has_many_attached にすることで複数画像に対応します
  # これにより、ビューで .count や .each が使えるようになります
  has_many_attached :images

  # いいね機能とコメント機能の紐付け（投稿削除時に一緒に消える設定）
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # バリデーション：本文が空の投稿を防ぐ
  validates :content, presence: true, length: { maximum: 140 }

  # ハッシュタグ用のメソッド（もし必要であれば残しておいてください）
  def self.search(search)
    if search != ""
      Post.where('content LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end
end