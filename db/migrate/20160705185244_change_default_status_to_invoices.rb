class ChangeDefaultStatusToInvoices < ActiveRecord::Migration
  def change
    change_column :invoices, :status, :integer, :default => 1
  end
end
