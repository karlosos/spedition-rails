class AddStreetToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :street, :text
  end
end
