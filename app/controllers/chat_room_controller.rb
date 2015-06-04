class ChatRoomController < ApplicationController

  def index
    render json: ChatRoom.all
  end

  # def time
  #   render json: ChatRoom.order(created_at: :desc).
  # end

  def create
    render json: ChatRoom.create(name: params[:name], message: params[:name])
  end
end
