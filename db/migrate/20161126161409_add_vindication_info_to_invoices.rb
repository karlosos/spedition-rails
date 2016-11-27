class AddVindicationInfoToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :vindication_emails, :string
    add_column :invoices, :vindication_last_email_type, :integer
  end
end
