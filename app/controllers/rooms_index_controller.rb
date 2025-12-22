class RoomsIndexController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分が参加しているEntryからRoomを取得
    @entries = current_user.entries.includes(:room)
    @rooms = @entries.map(&:room)
  end
end