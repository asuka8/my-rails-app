class RoomsController < ApplicationController
  before_action :authenticate_user!

  # DMのチャットルーム一覧
  def index
    # 自分が参加している全ルームのエントリ（Entry）を取得
    @entries = current_user.entries
    
    # 自分が参加しているルームに紐づく「相手側」のエントリを抽出
    # ルーム一覧で相手の名前やアイコンを表示するために必要
    my_room_ids = @entries.pluck(:room_id)
    @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id).order(created_at: :desc)
  end

  # チャット画面（DM詳細）
  def show
    @room = Room.find(params[:id])
    
    # 自分がこのルームに参加しているかチェック（セキュリティ）
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages.order(created_at: :asc)
      @message = Message.new
      @entries = @room.entries
      
      # --- 既読更新処理 ---
      # このルームのメッセージのうち、「自分以外が送った」かつ「未読(false)」のものを全て既読(true)にする
      unread_messages = @messages.where.not(user_id: current_user.id).where(checked: false)
      unread_messages.update_all(checked: true) if unread_messages.any?
      # -------------------
    else
      # 参加していないルームを勝手に見ようとした場合は戻す
      redirect_back(fallback_location: root_path, alert: "アクセス権限がありません。")
    end
  end

  # ルーム作成（ユーザー詳細ページなどの「メッセージを送る」ボタンから）
  def create
    @room = Room.create
    # 自分のエントリを作成
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    # 相手のエントリを作成（params[:entry][:user_id] で相手のIDを受け取っている前提）
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    
    redirect_to room_path(@room.id)
  end
end