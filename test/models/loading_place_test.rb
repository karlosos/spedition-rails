require 'test_helper'

class LoadingPlaceTest < ActiveSupport::TestCase
  def setup
    @loadingplace = loading_places(:loading_place_one)
  end

  test "city should be present" do
    @loadingplace.city = "      "
    assert_not @loadingplace.valid?
  end

  test "zip should be present" do
    @loadingplace.zip = "      "
    assert_not @loadingplace.valid?
  end

  test "country should be present" do
    @loadingplace.country = "      "
    assert_not @loadingplace.valid?
  end
end
