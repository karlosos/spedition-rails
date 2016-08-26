class AddTransportOrderAdditionalFields < ActiveRecord::Migration
  def change
    add_column :transport_orders, :speditor_name, :string
    add_column :transport_orders, :speditor_email, :string
    add_column :transport_orders, :vehicle_requirements, :text
    add_column :transport_orders, :payment_type, :text
    add_column :transport_orders, :additional_comments, :text
    add_column :transport_orders, :arrangements, :text
    add_column :transport_orders, :cmr_numer, :string
    add_column :transport_orders, :reference_transport_order_name, :string
  end
end
