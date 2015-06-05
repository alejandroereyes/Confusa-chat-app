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

  # def profile
  #   all_users = ChatRoom.select('name, message, created_at')

  # end


  def create
    if params[:name] != '' && params[:name] != nil
      new_msg = ChatRoom.new
      new_msg.name = params[:name]
      new_msg.message = params[:message]
      new_msg.room = params[:room] if params.has_key?(:room)
      new_msg.save
      # question for Zack if he uses what i send back or not? I could use this render for the bot
      if !(bot(params[:message]))
        render json: new_msg
      end
    else
      render json: { 'name'=> 'Hey...No Name!','message'=> 'Need to Enter a user name!' }, status: 431
    end
  end # create

  def bot(message)
    message == 'amiright' ? (render json: {'name' => 'Little Jerry Seinfeld', 'message'=> 'You are so right!'}) : nil
    message == 'what time is it?' ? (render json: {'name'=> 'Stanley Kirk Burrell', 'message'=> 'HAMMER  TIME'}) : nil
    message == '?' ? (render json: {'name'=> 'Abraham Lincoln', 'message'=> '.......must..eat...brain'}): nil
  end # bot
end # class

