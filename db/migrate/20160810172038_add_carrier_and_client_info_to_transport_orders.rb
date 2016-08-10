class AddCarrierAndClientInfoToTransportOrders < ActiveRecord::Migration
  def change
    add_column :transport_orders, :client_street, :text
    add_column :transport_orders, :client_name, :string
    add_column :transport_orders, :client_zip, :string
    add_column :transport_orders, :client_city, :string
    add_column :transport_orders, :client_country, :string
    add_column :transport_orders, :client_email, :string
    add_column :transport_orders, :client_phone, :string
    add_column :transport_orders, :carrier_name, :string
    add_column :transport_orders, :carrier_driver_name, :string
    add_column :transport_orders, :carrier_street, :string
    add_column :transport_orders, :carrier_country, :string
    add_column :transport_orders, :carrier_city, :string
    add_column :transport_orders, :carrier_zip, :string
  end
end
