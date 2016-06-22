class AddTaxationToInvoices < ActiveRecord::Migration
  def change
    add_money :invoices, :value_added_tax
    add_money :invoices, :net_price
    add_money :invoices, :total_selling_price
  end
end
