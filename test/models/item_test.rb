require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax: nil, unit_price_cents: Money.new(100, 'EUR'))
  end

  test "name should be present" do
    @item.name = "      "
    assert_not @item.valid?
  end

  test "unit should be present" do
    @item.unit = "      "
    assert_not @item.valid?
  end

  # test "quantity should be present" do
  #   @item.quantity = nil
  #   assert_not @item.valid?
  # end

  test "unit_price should be present" do
    @item.unit_price_cents = nil
    assert_not @item.valid?
  end

  # test "price should be updated after update" do
  #   money = Money.new(100, 'EUR')
  #   quantity = 4
  #   @item.unit_price = money
  #   @item.quantity = quantity
  #   @item.save
  #   assert_equal money * quantity, @item.price
  # end

end
