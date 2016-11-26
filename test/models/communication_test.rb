require 'test_helper'

class CommunicationTest < ActiveSupport::TestCase
  def setup
    @communication = communications(:communication_one)
  end

  test "vindication _must_be_present" do
    @communication.vindication = nil
    assert_not @communication.valid?
  end
end
