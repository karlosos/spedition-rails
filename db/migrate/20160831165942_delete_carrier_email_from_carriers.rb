class DeleteCarrierEmailFromCarriers < ActiveRecord::Migration
  def change
    remove_column :carriers, :carrier_email
  end
end
