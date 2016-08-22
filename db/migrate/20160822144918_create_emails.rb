class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.belongs_to :contact, index: true
      t.timestamps
    end
  end
end
