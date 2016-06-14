class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.belongs_to :invoice, index: true
      t.belongs_to :item, index: true
      t.timestamps
    end
  end
end
