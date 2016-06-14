class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :email
      t.string :www
      t.integer :contactable_id
      t.string :contactable_type


      t.timestamps
    end
    add_index :contacts, [:contactable_type, :contactable_id], :unique => true
  end
end
