class AddClientToCarrier < ActiveRecord::Migration
  def change
    add_reference :carriers, :client, index: true
  end
end
