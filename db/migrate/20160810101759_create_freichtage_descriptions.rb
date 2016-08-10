class CreateFreichtageDescriptions < ActiveRecord::Migration
  def change
    create_table :freichtage_descriptions do |t|
      t.decimal :weight
      t.decimal :value
      t.decimal :length
      t.decimal :width
      t.decimal :height
      t.decimal :packages
      t.string :packages_type
      t.belongs_to :transport_order, index: true

      t.timestamps
    end
  end
end
