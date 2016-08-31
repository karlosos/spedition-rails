class RemoveStaticLoadingPlacesFromTransportOrders < ActiveRecord::Migration
  def change
    remove_column :transport_orders, :loading_country
    remove_column :transport_orders, :loading_zip
    remove_column :transport_orders, :loading_city
    remove_column :transport_orders, :unloading_country
    remove_column :transport_orders, :unloading_zip
    remove_column :transport_orders, :unloading_city
  end
end
