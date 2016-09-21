class AddGroupReferenceToInvoiceNames < ActiveRecord::Migration
  def change
    add_reference :invoice_names, :group, index: true
  end
end
