class AddOverdueToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :deadline, :integer, :default => 50
  end
end
