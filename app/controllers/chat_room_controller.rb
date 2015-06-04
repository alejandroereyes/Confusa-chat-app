class ChatRoomController < ApplicationController

  def index
    render json: ChatRoom.all
  end

  # def time
  #   ChatRoom.where(:created_at => @selected_date.beginning_of_day..@selected_date.end_of_day)
  # end

  def create
    render json: ChatRoom.create(name: params[:name], message: params[:message])
  end
end
