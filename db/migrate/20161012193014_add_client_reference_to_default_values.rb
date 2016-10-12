class AddClientReferenceToDefaultValues < ActiveRecord::Migration
  def change
    add_reference :default_values, :client, index: true
  end
end
