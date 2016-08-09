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

  test "carrier should be present" do
    assert @transport_order.carrier.present?
    @transport_order.carrier = nil
    assert_not @transport_order.valid?
  end

  test "client should be present" do
    assert @transport_order.client.present?
    @transport_order.client = nil
    assert_not @transport_order.valid?
  end

  test "route should be present" do
    assert @transport_order.route.present?
    @transport_order.route = nil
    assert_not @transport_order.valid?
  end

  test "at least one loading_place should be present" do
    @transport_order.loading_places.each do |loading_places|
      @transport_order.loading_places.delete(loading_places)
    end
    assert_equal 0, @transport_order.loading_places.size
    assert_not @transport_order.valid?
  end

  test "at least one unloading_place should be present" do
    @transport_order.unloading_places.each do |unloading_place|
      @transport_order.unloading_places.delete(unloading_place)
    end
    assert_equal 0, @transport_order.unloading_places.size
    assert_not @transport_order.valid?
  end
end
