require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    @address = Address.new(line1: "ul. Cicha 132 m.16", city: "Gniezno", zip: "62-200", country: "Polska")
  end

  test "line1 should be present" do
    @address.line1 = "      "
    assert_not @address.valid?
  end

  test "city should be present" do
    @address.city = "      "
    assert_not @address.valid?
  end

  test "zip should be present" do
    @address.zip = "      "
    assert_not @address.valid?
  end

  test "country should be present" do
    @address.country = "      "
    assert_not @address.valid?
  end

  test "line2 don't need to be present" do
    @address.line2 = ""
    assert @address.valid?
  end

  test "state don't need to be present" do
    @address.state = ""
    assert @address.valid?
  end
end
