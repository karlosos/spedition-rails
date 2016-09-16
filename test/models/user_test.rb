require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  test "email must be unique" do
    user = @user.dup
    assert_not user.valid?
  end
end
