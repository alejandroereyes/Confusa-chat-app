class ChatRoomController < ApplicationController

  def index
    render json: ChatRoom.all
  end

  def leaderboard
    board = ChatRoom.all.group_by { |room| room.name }
                          .sort_by { |name, message| message.count }
                          .reverse.take(10).map { |rooms| rooms.first }
    render json: board
  end

  def time
    time_now = Time.now
    last_five_min = []
    all_msg = ChatRoom.all

    all_msg.each do |message|
      if (time_now - message.created_at) <= 300000
        last_five_min << message
      end
    end
    render json: last_five_min
  end

  def create
    render json: ChatRoom.create(name: params[:name], message: params[:message])
  end
end
