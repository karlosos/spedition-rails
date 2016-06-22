class AddTaxationToInvoiceItems < ActiveRecord::Migration
  def change
    add_column :invoice_items, :tax_rate, :integer
    add_money :invoice_items, :value_added_tax
    add_money :invoice_items, :net_price
    add_money :invoice_items, :total_selling_price
  end
end
