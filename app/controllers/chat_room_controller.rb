class ChatRoomController < ApplicationController

  def index
    time_start = params.has_key?(:start_messages) ? params[:start_messages] : 300
    render json: ChatRoom.all.select { |message| message.created_at > (Time.now - time_start) }
  end

  def leaderboard
    board = ChatRoom.all.group_by { |room| room.name }
                          .sort_by { |name, message| message.count }
                          .reverse.take(10).map { |rooms| rooms.first } #flick it ;)
    render json: board
  end


  def recent_users
    time_start = params.has_key?(:start_users) ? params[:start_users] : 14400 # 14400 sec = 4 hours
    render json: ChatRoom.all.select { |user| user.created_at > (Time.now - time_start) }
  end


  def create
    if params[:name] != '' && params[:name] != nil
      new_msg = ChatRoom.new
      new_msg.name = params[:name]
      new_msg.message = params[:message]
      new_msg.room = params[:room] if params.has_key?(:room)
      new_msg.save
      render json: new_msg
    else
      render json: { 'name'=> 'Hey...No Name!','message'=> 'Need to Enter a user name!' }, status: 431
    end
  end # create
end # class

