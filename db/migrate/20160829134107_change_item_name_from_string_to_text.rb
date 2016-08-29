class ChangeItemNameFromStringToText < ActiveRecord::Migration
  def change
    change_column :items, :name, :text
  end
end
