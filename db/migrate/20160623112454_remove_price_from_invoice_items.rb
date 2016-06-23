class RemovePriceFromInvoiceItems < ActiveRecord::Migration
  def change
    remove_money :invoice_items, :price
  end
end
