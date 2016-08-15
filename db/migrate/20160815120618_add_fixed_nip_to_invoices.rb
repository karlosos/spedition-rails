class AddFixedNipToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :client_nip, :string
  end
end
