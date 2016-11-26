class CreateVindications < ActiveRecord::Migration
  def change
    create_table :vindications do |t|
      t.references :invoice, index: true
      t.string :ticket_number
      t.integer :last_email_type
      t.string :emails

      t.timestamps
    end
  end
end
