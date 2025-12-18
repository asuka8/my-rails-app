class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # プロフィール写真との紐付けを追加
  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
end