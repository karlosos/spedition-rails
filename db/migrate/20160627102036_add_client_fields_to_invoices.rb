class AddClientFieldsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :client_street, :text
    add_column :invoices, :client_name, :string
    add_column :invoices, :client_zip, :string
    add_column :invoices, :client_city, :string
    add_column :invoices, :client_country, :string
    add_column :invoices, :client_email, :string
    add_column :invoices, :client_phone, :string
  end
end
