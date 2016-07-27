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
end
