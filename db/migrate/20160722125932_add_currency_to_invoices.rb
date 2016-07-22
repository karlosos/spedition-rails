class AddCurrencyToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_currency, :string, :default => 'EUR'
    add_column :invoices, :invoice_exchange_currency, :string, :default => 'PLN'
    add_column :invoices, :invoice_language, :string, :default => 'PL'
  end
end
