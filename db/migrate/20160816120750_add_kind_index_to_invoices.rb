class AddKindIndexToInvoices < ActiveRecord::Migration
  def change
    add_index :invoices, :kind
  end
end
