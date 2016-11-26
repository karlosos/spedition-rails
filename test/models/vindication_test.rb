require 'test_helper'

class VindicationTest < ActiveSupport::TestCase
  def setup
    @vindication = vindications(:vindication_one)
  end

  test "invoice must be present" do
    @vindication.invoice = nil
    assert_not @vindication.valid?
  end

  test "invoice must be unique" do
    vindication_dup = @vindication.dup
    assert_not vindication_dup.valid?
  end
end
