class CreateInvoiceNames < ActiveRecord::Migration
  def change
    create_table :invoice_names do |t|
      t.integer :number
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
