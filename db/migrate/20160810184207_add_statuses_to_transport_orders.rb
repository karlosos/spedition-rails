class AddStatusesToTransportOrders < ActiveRecord::Migration
  def change
    add_column :transport_orders, :loading_status, :boolean, :default => false
    add_column :transport_orders, :unloading_status, :boolean, :default => false
    add_column :transport_orders, :driver_documents_status, :boolean, :default => false
  end
end
