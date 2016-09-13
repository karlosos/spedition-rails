class AddAccountingEmailToClients < ActiveRecord::Migration
  def change
    add_column :clients, :accounting_email, :string
  end
end
