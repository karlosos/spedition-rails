require 'test_helper'

class TransportOrderNameTest < ActiveSupport::TestCase
  def setup
    @transport_order_name = transport_order_names(:transport_order_name_one)
  end

  test "number should be present" do
    assert @transport_order_name.number.present?
    @transport_order_name.number = nil
    assert_not @transport_order_name.valid?
  end

  test "year order should be present" do
    assert @transport_order_name.year.present?
    @transport_order_name.year = nil
    assert_not @transport_order_name.valid?
  end
end
