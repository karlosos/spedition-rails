class CreateCarrierMemberships < ActiveRecord::Migration
  def change
    create_table :carrier_memberships do |t|
      t.references :user, index: true
      t.references :carrier, index: true

      t.timestamps
    end
  end
end
