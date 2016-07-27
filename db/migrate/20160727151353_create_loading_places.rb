class CreateLoadingPlaces < ActiveRecord::Migration
  def change
    create_table :loading_places do |t|
      t.belongs_to :transport_order, index: true
      t.string :city
      t.string :zip
      t.string :country
      t.datetime :date
      t.timestamps
    end
  end
end
