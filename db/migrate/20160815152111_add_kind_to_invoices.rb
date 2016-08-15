class AddKindToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :kind, :string
  end
end
