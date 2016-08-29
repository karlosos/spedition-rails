class AddTransportOrderToItem < ActiveRecord::Migration
  def change
    add_reference :items, :transport_order, index: true
  end
end
