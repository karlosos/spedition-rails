require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @group = groups(:group_one)
  end

  test "should get index" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create group" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Group.count') do
      post :create, group: {
        "name" => "New group",
        "domain" => "new_group"
      }
    end

    assert_redirected_to group_path(assigns(:group))
  end

  test "should not create group if not logged in" do
    assert_no_difference('Group.count') do
      post :create, group: {
        "name" => "New group",
        "domain" => "new_group"
      }
    end
  end

  test "should show group" do
    @request.host = "groupone.lvh.me:3000"
    sign_in users(:user_one)
    get :show, id: @group
    assert_response :success
  end

  test "should get edit" do
    @request.host = "groupone.lvh.me:3000"
    sign_in users(:user_one)
    get :edit, id: @group
    assert_response :success
  end

  test "should update group" do
    @request.host = "groupone.lvh.me:3000"
    sign_in users(:user_one)
    patch :update, id: @group, group: {
      "name" => "New group",
      "domain" => "new_group"
    }
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    @request.host = "groupone.lvh.me:3000"
    sign_in users(:user_one)
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group
    end

    assert_redirected_to groups_path
  end
end
