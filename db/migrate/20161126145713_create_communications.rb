class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.references :invoice, index: true
      t.date :date
      t.text :note
      t.references :user, index: true

      t.timestamps
    end
  end
end
