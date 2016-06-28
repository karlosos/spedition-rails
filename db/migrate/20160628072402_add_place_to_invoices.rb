class AddPlaceToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :place, :string
  end
end
