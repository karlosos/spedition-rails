class AddProfitMarginToTransportOrders < ActiveRecord::Migration
  def change
    add_money :transport_orders, :profit_margin
  end
end
