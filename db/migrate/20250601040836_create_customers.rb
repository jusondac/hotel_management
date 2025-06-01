class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :full_name
      t.string :address
      t.string :city

      t.timestamps
    end
  end
end
