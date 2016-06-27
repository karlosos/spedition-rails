class AddClientFieldsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :client_street, :text
    add_column :invoices, :client_name, :string
  end
end
