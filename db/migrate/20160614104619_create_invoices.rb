class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.datetime :date
      t.integer :client_id
      t.integer :seller_id
      t.timestamps
    end
  end
end
