class AddFixedNipToTransportOrders < ActiveRecord::Migration
  def change
    add_column :transport_orders, :client_nip, :string
    add_column :transport_orders, :carrier_nip, :string
  end
end
