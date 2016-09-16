require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @item = items(:item_one)
  end

  test "should get index" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create item" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Item.count') do
      post :create, item: { name: "test", unit: "test", tax_rate_id: tax_rates(:tax_rate_one).id, unit_price: Money.new(120.3, 'EUR') }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :show, id: @item
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @item
    assert_response :success
  end

  test "should update item" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    patch :update, id: @item, item: { name: "test", unit: "test", tax_rate_id: tax_rates(:tax_rate_one).id, unit_price: Money.new(120.3, 'EUR') }
    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    sign_in users(:user_one)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to items_path
  end
end
