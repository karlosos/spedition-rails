class AddPriceInWordsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :total_price_in_words, :string
  end
end
