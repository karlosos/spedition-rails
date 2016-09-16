require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = groups(:group_one)
  end

  test "subdomain must be unique" do
    group = Group.new()
    group.name = "New name"
    group.subdomain = @group.subdomain
    assert_not group.valid?
  end
end
