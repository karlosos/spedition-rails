class AddTransportOrderValuesToDefaultValues < ActiveRecord::Migration
  def change
    add_column :default_values, :vehicle_requirements, :text
    add_column :default_values, :additional_comments, :text
    add_column :default_values, :arrangements, :text
  end
end
