class ChatRoomController < ApplicationController

  def index
    time_start = params.has_key?(:start_messages) ? params[:start_messages] : 300
    room = params[:room] != 'global' ? params[:room] : 'global'
    room = (room == nil || room == false) ? 'global': room
    messages = ChatRoom.where(room: room).select { |message| message.created_at > (Time.now - time_start) }
    # messages.map!{ |message| message[:created_at] = message[:created_at].strftime("%-d/%-m %H:%M") }
    render json: messages
  end

  def old_index
    time_start = params.has_key?(:start_messages) ? params[:start_messages] : 300
    messages = ChatRoom.all.select { |message| message.created_at > (Time.now - time_start) }
    messages.each_with_index{ |message, index| messages[index][:created_at] = messages[index][:created_at].strftime("%-d/%-m %H:%M") }
    render json: messages
  end

  def leaderboard
    board = ChatRoom.all.group_by { |room| room.name }
                          .sort_by { |name, message| message.count }
                          .reverse.take(10).map { |rooms| rooms.first } #flick it ;)

    # stats = ChatRoom.all.group_by { |user| user.name }
                        # .sort_by { |key, value| value.count }
    render json: board
  end

  def recent_users
    time_start = params.has_key?(:start_users) ? params[:start_users] : 14400 # 14400 sec = 4 hours
    users = ChatRoom.group(:name, :id).select { |user| user.created_at > (Time.now - time_start) }
                    .group_by { |key, value| key.name }
                    .map{ |arr| arr.first }

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
    render json: ChatRoom.group(:room)
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
      # reply.room = params[:room]
      reply.save
    when 'what time is it'
      reply.name = 'Stanley Kirk Burrel'
      reply.message = "HAMMER    TIME"
      # reply.room = params[:room]
      reply.save
    when '?'
      reply.name = 'Abraham Lincoln'
      reply.message = '.....must..Eat...BRAIN'
      # reply.room = params[:room]
      reply.save
    end
  end # bot
end # class

