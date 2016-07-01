class AddCurrencyRateInfoToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :currency_rate_table_name, :string
    add_column :invoices, :currency_rate_name, :string
    add_column :invoices, :currency_rate, :decimal
  end
end
