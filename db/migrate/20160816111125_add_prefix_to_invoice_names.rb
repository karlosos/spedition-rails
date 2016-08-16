class AddPrefixToInvoiceNames < ActiveRecord::Migration
  def change
    add_column :invoice_names, :prefix, :string
  end
end
