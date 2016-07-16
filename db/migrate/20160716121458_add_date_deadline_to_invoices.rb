class AddDateDeadlineToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :date_deadline, :DateTime
  end
end
