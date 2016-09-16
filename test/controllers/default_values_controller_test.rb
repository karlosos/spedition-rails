require 'test_helper'

class DefaultValuesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @default_value = default_values(:default_value_one)
  end

  test "should get index" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:default_values)
  end

  test "should get new" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create default_value" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('DefaultValue.count') do
      post :create, default_value: {
        "group_id" => groups(:group_one).id,
        "place" => "Szczecin"
       }
    end

    assert_redirected_to default_value_path(assigns(:default_value))
  end

  test "should show default_value" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :show, id: @default_value
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @default_value
    assert_response :success
  end

  test "should update default_value" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    patch :update, id: @default_value, default_value: {
      "group_id" => groups(:group_one).id,
      "place" => "Szczecin"
     }
    assert_redirected_to default_value_path(assigns(:default_value))
  end

  test "should destroy default_value" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('DefaultValue.count', -1) do
      delete :destroy, id: @default_value
    end

    assert_redirected_to default_values_path
  end
end
