class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }
  # 以下のバリデーションを追記
  validate :no_self_like

  private

  def no_self_like
    if user_id == post.user_id
      errors.add(:base, "自分の投稿にはいいねできません")
    end
  end
end