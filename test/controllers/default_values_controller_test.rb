require 'test_helper'

class DefaultValuesControllerTest < ActionController::TestCase
  setup do
    @default_value = default_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:default_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create default_value" do
    assert_difference('DefaultValue.count') do
      post :create, default_value: {  }
    end

    assert_redirected_to default_value_path(assigns(:default_value))
  end

  test "should show default_value" do
    get :show, id: @default_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @default_value
    assert_response :success
  end

  test "should update default_value" do
    patch :update, id: @default_value, default_value: {  }
    assert_redirected_to default_value_path(assigns(:default_value))
  end

  test "should destroy default_value" do
    assert_difference('DefaultValue.count', -1) do
      delete :destroy, id: @default_value
    end

    assert_redirected_to default_values_path
  end
end
