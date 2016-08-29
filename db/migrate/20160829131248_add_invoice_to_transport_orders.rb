class AddInvoiceToTransportOrders < ActiveRecord::Migration
  def change
    add_reference :transport_orders, :invoice, index: true
  end
end
