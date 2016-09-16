class AddDefaultInvoiceCurrencyToClients < ActiveRecord::Migration
  def change
    change_column :clients, :invoice_currency, :string, :default => "EUR"
  end
end
