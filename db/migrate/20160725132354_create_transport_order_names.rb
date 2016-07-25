class CreateTransportOrderNames < ActiveRecord::Migration
  def change
    create_table :transport_order_names do |t|
      t.integer :number
      t.integer :year
      t.belongs_to :transport_order, index: true
      t.timestamps
    end
  end
end
