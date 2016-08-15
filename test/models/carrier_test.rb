require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  def setup
    @carrier = carriers(:carrier_one)
  end

  test "registration_number should be present" do
    assert @carrier.registration_number.present?
    @carrier.registration_number = nil
    assert_not @carrier.valid?
  end

  test "size should be present" do
    assert @carrier.size.present?
    @carrier.size = nil
    assert_not @carrier.valid?
  end

  test "carrier name should be present" do
    assert @carrier.carrier_name.present?
    @carrier.carrier_name = nil
    assert_not @carrier.valid?
  end

  test "carrier email should be present" do
    assert @carrier.carrier_email.present?
    @carrier.carrier_email = nil
    assert_not @carrier.valid?
  end

  test "driver name should be present" do
    assert @carrier.driver_name.present?
    @carrier.driver_name = nil
    assert_not @carrier.valid?
  end

  test "driver email should be present" do
    assert @carrier.driver_email.present?
    @carrier.driver_email = nil
    assert_not @carrier.valid?
  end

  test "should be removed if has transport_orders" do
    @carrier.transport_orders.each do |transport_order|
        @carrier.transport_orders.delete(transport_order)
      end
    assert_difference('Carrier.count', -1) do
      @carrier.destroy
    end
  end

  test "should not be removed if has transport_orders" do
    assert @carrier.transport_orders.count > 0
    assert_difference('Carrier.count', 0) do
      @carrier.destroy
    end
  end
end
