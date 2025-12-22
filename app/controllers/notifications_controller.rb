class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分宛の通知をすべて取得（passive_notifications は user.rb で定義したもの）
    @notifications = current_user.passive_notifications.order(created_at: :desc)
    
    # 未読(checked: false)の通知を探して、すべて既読(checked: true)に一括更新
    @notifications.where(checked: false).update_all(checked: true)
  end
end