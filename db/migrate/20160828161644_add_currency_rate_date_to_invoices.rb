class AddCurrencyRateDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :currency_rate_date, :datetime
  end
end
