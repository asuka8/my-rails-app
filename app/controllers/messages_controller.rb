class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    # 入力された内容とルームIDを取得し、自分のIDを紐付けてインスタンス作成
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      # --- 通知作成ロジック ---
      # ルームの参加者（自分以外）を探す
      @room = @message.room
      @entries = @room.entries.where.not(user_id: current_user.id)
      
      @entries.each do |entry|
        # 通知を送る（相手が複数の場合にも対応可能な構造）
        notification = current_user.active_notifications.new(
          visited_id: entry.user_id,
          post_id: nil, # DMなので投稿IDはなし
          action: 'message'
        )
        # 自分のメッセージに対する通知なので、既読でない限り保存
        notification.save if notification.valid?
      end
      # -----------------------

      # 送信したチャットルームの画面にリダイレクト
      redirect_to room_path(@message.room_id)
    else
      # 保存に失敗した場合は元の画面に戻る
      flash[:alert] = "メッセージの送信に失敗しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end