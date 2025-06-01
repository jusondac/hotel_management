class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.float :price, null: false
      t.boolean :available, default: true
      t.references :room_type, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
