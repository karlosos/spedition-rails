class AddDefaultQuantityToInvoiceItems < ActiveRecord::Migration
  def change
    change_column :invoice_items, :quantity, :integer, :default => 1
  end
end
