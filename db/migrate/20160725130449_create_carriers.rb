class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :registration_number
      t.string :size
      t.string :carrier_name
      t.string :carrier_email
      t.string :driver_name
      t.string :driver_email
      t.timestamps
    end
  end
end
