class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 追記：空欄を禁止する
  validates :content, presence: true
end