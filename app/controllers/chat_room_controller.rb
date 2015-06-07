class ChatRoomController < ApplicationController

  def index
    time_start = params.has_key?(:start_messages) ? params[:start_messages].to_i : 300
    room = params[:room] != 'global' ? params[:room] : 'global'
    room = (room == nil || room == false) ? 'global': room
    messages = ChatRoom.where(room: room).select { |message| message.created_at > (Time.now - time_start) }
    render json: messages
  end

  def leaderboard
    board = ChatRoom.all.group_by { |room| room.name }
                          .sort_by { |name, message| message.count }
                          .reverse.take(10).map { |rooms| {name: rooms.first, total_messages: rooms[1].count} } #flick it ;)
    render json: board
  end

  def recent_users
    time_start = params.has_key?(:start_users) ? params[:start_users] : 14400 # 14400 sec = 4 hours
    users = ChatRoom.group(:name, :id).select { |user| user.created_at > (Time.now - time_start) }
                    .group_by { |key, value| key.name }
                    .map{ |arr| arr.first }.take(10)

    render json: users
  end

  def top_rooms
    rooms = ChatRoom.all.group_by { |room| room.room }
                        .sort_by { |key, value| value.count }
                        .reverse.take(3).map{ |rooms| rooms.first }
    render json: rooms
  end

  def profile
    render json: ChatRoom.select('name, message, created_at').where(name: "#{params[:name]}")
  end

  def all_rooms
    render json: ChatRoom.group(:room, :id).group_by{ |row| row.room }
                          .map { |element| element.first }
  end

  def room_history
    puts "*******  #{params}  ********"
    if params[:start_time] != nil && params[:end_time] != nil && params.has_key?(:start_time) && params.has_key?(:end_time)
      begin
        if params[:start_time] == params[:end_time]
          one_day = []
          ChatRoom.where(room: "#{params[:room]}").select do |message|
                                                    if message.created_at.strftime("%-m-%-d-%y") == params[:start_time]
                                                        one_day << message
                                                    end
                                                  end
          render json: one_day
        else
          history = ChatRoom.where(room: "#{params[:room]}").select do |msg|
                                                          msg.created_at.strftime("%-m-%-d-%y") >= params[:start_time] &&
                                                          msg.created_at.strftime("%-m-%-d-%y") <= params[:end_time]
                                                        end
          render json: history
        end
      rescue ActiveRecord::RecordNotFound => error
        render json: { error: error.message }, status: 404
      end
    else
      render json: { error: "Missing time parameters!" }, status: 422
    end
  end

  def create
      if params[:name] != '' && params[:name] != nil
        new_msg = ChatRoom.new
        new_msg.name = params[:name]
        new_msg.message = Swearjar.default.censor(params[:message])
        new_msg.room = params[:room] if params.has_key?(:room)
        new_msg.save
        bot
        render json: new_msg
      else
        render json: { 'name'=> 'Hey...No Name!','message'=> 'Need to Enter a user name!' }, status: 431
      end
  end # create

  def bot
    reply = ChatRoom.new
    case params[:message]
    when 'amiright'
      reply.name = 'Little Jerry Seinfeld'
      reply.message = "What's the deal with helicopters !?"
      reply.room = params[:room]
      reply.save
    when 'what time is it'
      reply.name = 'Stanley Kirk Burrel'
      reply.message = "HAMMER    TIME"
      reply.room = params[:room]
      reply.save
    when '?'
      reply.name = 'Abraham Lincoln'
      reply.message = '.....must..Eat...BRAIN'
      reply.room = params[:room]
      reply.save
    end
  end # bot
end # class

