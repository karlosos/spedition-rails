require 'test_helper'

class CarrierMembershipsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @carrier_membership = carrier_memberships(:carrier_membership_one)
  end

  test "should get index" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:carrier_memberships)
  end

  test "should get new" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create carrier_membership" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('CarrierMembership.count') do
      post :create, carrier_membership: { "carrier_id" => carriers(:carrier_one).id, "user_id" => users(:user_speditor).id }
    end

    assert_redirected_to carrier_memberships_path
  end

  test "should show carrier_membership" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :show, id: @carrier_membership
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @carrier_membership
    assert_response :success
  end

  test "should update carrier_membership" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    patch :update, id: @carrier_membership, carrier_membership: { "carrier_id" => carriers(:carrier_one).id, "user_id" => users(:user_speditor).id }
    assert_redirected_to carrier_memberships_path
  end

  test "should destroy carrier_membership" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('CarrierMembership.count', -1) do
      delete :destroy, id: @carrier_membership
    end

    assert_redirected_to carrier_memberships_path
  end
end
