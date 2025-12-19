class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 } # 140文字制限
  default_scope -> { order(created_at: :desc) } # 新しい投稿を上にする
  has_many :likes, dependent: :destroy
  # 投稿を「いいね」しているユーザーを直接取得できるようにする
  has_many :liked_users, through: :likes, source: :user
end