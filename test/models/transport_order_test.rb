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

  test "loading country should be present" do
    assert @transport_order.loading_country.present?
    @transport_order.loading_country = nil
    assert_not @transport_order.valid?
  end

  test "loading zip should be present" do
    assert @transport_order.loading_zip.present?
    @transport_order.loading_zip = nil
    assert_not @transport_order.valid?
  end

  test "loading city should be present" do
    assert @transport_order.loading_city.present?
    @transport_order.loading_city = nil
    assert_not @transport_order.valid?
  end

  test "unloading country should be present" do
    assert @transport_order.unloading_country.present?
    @transport_order.unloading_country = nil
    assert_not @transport_order.valid?
  end

  test "unloading zip should be present" do
    assert @transport_order.unloading_zip.present?
    @transport_order.unloading_zip = nil
    assert_not @transport_order.valid?
  end

  test "unloading city should be present" do
    assert @transport_order.unloading_city.present?
    @transport_order.loading_city = nil
    assert_not @transport_order.valid?
  end

end
