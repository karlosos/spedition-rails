class AddNipToCarriers < ActiveRecord::Migration
  def change
    add_column :carriers, :nip, :string
  end
end
