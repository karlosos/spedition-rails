require 'test_helper'

class CommunicationTest < ActiveSupport::TestCase
  def setup
    @communication = communications(:communication_one)
  end

  test "invoice _must_be_present" do
    @communication.invoice = nil
    assert_not @communication.valid?
  end
end
