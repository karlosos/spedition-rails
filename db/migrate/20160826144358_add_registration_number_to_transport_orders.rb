class AddRegistrationNumberToTransportOrders < ActiveRecord::Migration
  def change
    add_column :transport_orders, :car_registration_number, :string
  end
end
