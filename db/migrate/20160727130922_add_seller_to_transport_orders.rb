class AddSellerToTransportOrders < ActiveRecord::Migration
  def change
    add_column :transport_orders, :seller_id, :integer
  end
end
