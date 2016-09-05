class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :pkwiu
      t.string :unit
      t.timestamps
    end
  end
end
