class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id))
      if @message.save
        # --- 通知の作成 ---
        # 部屋の自分以外のユーザー（相手）を探す
        @room = @message.room
        @opponent_entry = @room.entries.where.not(user_id: current_user.id).first
        
        notification = current_user.active_notifications.new(
          visited_id: @opponent_entry.user_id,
          action: 'message' # 新しいアクションタイプ
        )
        notification.save if notification.valid?
        # ------------------
        
        redirect_to "/rooms/#{@message.room_id}"
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end
end