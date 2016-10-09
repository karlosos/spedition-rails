class AddClientValuesToDefaultValues < ActiveRecord::Migration
  def change
    add_column :default_values, :invoice_currency, :string
    add_reference :default_values, :tax_rate, index: true
    add_column :default_values, :invoice_language, :string
    add_column :default_values, :payment_term, :integer
  end
end
