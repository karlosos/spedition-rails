class AddPriceToItems < ActiveRecord::Migration
  def change
  add_money :items, :unit_price

  #add_monetize :items, :price
  #add_monetize :items, :unit_price
end
end
