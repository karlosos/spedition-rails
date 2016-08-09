require 'test_helper'

class UnloadingPlaceTest < ActiveSupport::TestCase
  def setup
    @unloadingplace = unloading_places(:unloading_place_one)
  end

  test "city should be present" do
    @unloadingplace.city = "      "
    assert_not @unloadingplace.valid?
  end

  test "zip should be present" do
    @unloadingplace.zip = "      "
    assert_not @unloadingplace.valid?
  end

  test "country should be present" do
    @unloadingplace.country = "      "
    assert_not @unloadingplace.valid?
  end
end
