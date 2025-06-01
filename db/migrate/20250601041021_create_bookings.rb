class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :customer, null: false, foreign_key: true
      t.date :start_date
      t.date :finish_date
      t.integer :payment_method

      t.timestamps
    end
  end
end
