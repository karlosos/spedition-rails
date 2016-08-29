class AddSelllDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :sell_date, :datetime
  end
end
