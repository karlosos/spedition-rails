class AddDefaultTaxRateToInvoiceItems < ActiveRecord::Migration
  def change
    change_column :invoice_items, :tax_rate, :integer, :default => 23
  end
end
