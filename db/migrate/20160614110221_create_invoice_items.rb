class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.belongs_to :invoice, index: true
      t.belongs_to :item, index: true
      t.integer :quantity
      t.timestamps
    end
    add_money :invoice_items, :price
    add_money :invoice_items, :unit_price
  end
end
