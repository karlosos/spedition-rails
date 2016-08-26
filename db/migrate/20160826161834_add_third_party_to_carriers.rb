class AddThirdPartyToCarriers < ActiveRecord::Migration
  def change
    add_column :carriers, :is_third_party, :boolean
  end
end
