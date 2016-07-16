class AddDateDeadlineToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :date_deadline, :datetime
  end
end
