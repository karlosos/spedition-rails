class AddTaxRateAssociationsToItems < ActiveRecord::Migration
  def change
    add_reference :items, :tax_rate, index: true
    add_reference :invoice_items, :tax_rate, index: true
    add_column :invoice_item_corrections, :tax_rate_id, :integer
    add_index :invoice_item_corrections, :tax_rate_id
    add_column :invoice_item_corrections, :tax_rate_correction_id, :integer
    add_index :invoice_item_corrections, :tax_rate_correction_id
  end
end
