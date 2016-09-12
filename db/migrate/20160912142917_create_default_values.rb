class CreateDefaultValues < ActiveRecord::Migration
  def change
    create_table :default_values do |t|
      t.references :group, index: true
      t.string :invoice_place

      t.timestamps
    end
  end
end
