require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax_rate_id: tax_rates(:tax_rate_one).id, unit_price_cents: Money.new(100, 'EUR'))
  end

  test "name should be present" do
    @item.name = "      "
    assert_not @item.valid?
  end

  test "unit should be present" do
    @item.unit = "      "
    assert_not @item.valid?
  end

  test "unit_price should be present" do
    @item.unit_price_cents = nil
    assert_not @item.valid?
  end

end
