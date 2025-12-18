class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 } # 140文字制限
  default_scope -> { order(created_at: :desc) } # 新しい投稿を上にする
end