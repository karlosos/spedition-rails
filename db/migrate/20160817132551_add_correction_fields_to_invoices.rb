class AddCorrectionFieldsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_to_correct_id, :integer
    add_column :invoices, :correction_cause, :text
  end
end
