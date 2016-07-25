require 'test_helper'

class TransportOrderTest < ActiveSupport::TestCase
  def setup
    @transport_order = transport_orders(:transport_order_one)
  end

  test "transport_order_name should be present" do
    assert @transport_order.transport_order_name.get_name.present?
    @transport_order.transport_order_name = nil
    assert_not @transport_order.valid?
  end
end
