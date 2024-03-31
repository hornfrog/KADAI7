class AddImageUrlToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :room_image_id, :string
  end
end
