class CreateInvoiceItemCorrections < ActiveRecord::Migration
  def change
    create_table :invoice_item_corrections do |t|
      t.belongs_to :invoice, index: true
      t.belongs_to :item, index: true
      t.string :item_name
      t.string :item_name_correction
      t.integer :quantity, :default => 1
      t.integer :quantity_correction, :default => 1
      t.integer :quantity_difference, :default => 1
      t.integer :tax_rate, :default => 23
      t.integer :tax_rate_correction, :default => 23
      t.timestamps
    end
    add_money :invoice_item_corrections, :unit_price
    add_money :invoice_item_corrections, :unit_price_correction
    add_money :invoice_item_corrections, :unit_price_difference
    add_money :invoice_item_corrections, :value_added_tax
    add_money :invoice_item_corrections, :value_added_tax_correction
    add_money :invoice_item_corrections, :value_added_tax_difference
    add_money :invoice_item_corrections, :net_price
    add_money :invoice_item_corrections, :net_price_correction
    add_money :invoice_item_corrections, :net_price_difference
    add_money :invoice_item_corrections, :total_selling_price
    add_money :invoice_item_corrections, :total_selling_price_correction
    add_money :invoice_item_corrections, :total_selling_price_difference
  end
end
