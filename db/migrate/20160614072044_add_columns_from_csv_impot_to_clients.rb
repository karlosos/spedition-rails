class AddColumnsFromCsvImpotToClients < ActiveRecord::Migration
  def change
    add_column :clients, :regon, :string
    add_column :clients, :pesel, :string
    add_column :clients, :nip, :string
    add_column :clients, :invoice_currency, :string
    add_column :clients, :freight_currency, :string
    add_column :clients, :payment_term, :integer
    add_column :clients, :invoice_language, :string
  end
end
