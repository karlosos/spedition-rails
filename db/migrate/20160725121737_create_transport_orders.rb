class CreateTransportOrders < ActiveRecord::Migration
  def change
    create_table :transport_orders do |t|
      t.integer :client_id
      t.integer :carrier_id
      t.string :route
      t.decimal :distance
      t.string :loading_country
      t.string :loading_zip
      t.string :loading_city
      t.datetime :loading_date
      t.string :unloading_country
      t.string :unloading_zip
      t.string :unloading_city
      t.datetime :unloading_date
      t.timestamps
    end
    add_money :transport_orders, :freight_rate
  end
end
