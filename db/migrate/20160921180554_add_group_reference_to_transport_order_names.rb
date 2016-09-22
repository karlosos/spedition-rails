class AddGroupReferenceToTransportOrderNames < ActiveRecord::Migration
  def change
    add_reference :transport_order_names, :group, index: true
  end
end
