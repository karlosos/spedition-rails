class AddPhoneToCarriers < ActiveRecord::Migration
  def change
    add_column :carriers, :driver_phone, :string
  end
end
