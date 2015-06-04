class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string :name, null: false
      t.string :room, null: false, default: 'global'
      t.text   :message, null: false
      t.timestamps null: false
    end
  end
end
