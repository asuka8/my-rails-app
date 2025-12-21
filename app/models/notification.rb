class Notification < ApplicationRecord
  # visitor: 通知を送った人, visited: 通知を受け取った人
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  belongs_to :post, optional: true
end