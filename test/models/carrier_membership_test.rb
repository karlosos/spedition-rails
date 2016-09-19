require 'test_helper'

class CarrierMembershipTest < ActiveSupport::TestCase
  def setup
    @carrier_membership = carrier_memberships(:carrier_membership_one)
  end

  test "carrier should be present" do
    @carrier_membership.carrier = nil
    assert_not @carrier_membership.valid?
  end

  test "user should be present" do
    @carrier_membership.user = nil
    assert_not @carrier_membership.valid?
  end

  test "association must be unique" do
    new_membership = @carrier_membership.dup
    assert_not new_membership.valid?
  end
end
