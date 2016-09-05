require 'test_helper'

class CarriersControllerTest < ActionController::TestCase
  setup do
    @carrier = carriers(:carrier_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carriers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carrier" do
    assert_difference('Carrier.count') do
      post :create, carrier: {
        registration_number: "ZS32201",
        size: "2m x 3m",
        driver_name: "Karol Cichy",
        driver_email: "cichy@email.com",
        carrier_name: "Trans",
      }
    end

    assert_redirected_to carrier_path(assigns(:carrier))
  end

  test "should show carrier" do
    get :show, id: @carrier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carrier
    assert_response :success
  end

  test "should update carrier" do
    patch :update, id: @carrier, carrier: {
      registration_number: "ZS32201",
      size: "2m x 3m",
      driver_name: "Karol Cichy",
      driver_email: "cichy@email.com",
      carrier_name: "Trans",
    }
    assert_redirected_to carrier_path(assigns(:carrier))
  end

  test "should destroy carrier" do
    @carrier.transport_orders.each do |transport_order|
        @carrier.transport_orders.delete(transport_order)
      end
    assert_difference('Carrier.count', -1) do
      delete :destroy, id: @carrier
    end

    assert_redirected_to carriers_path
  end

  test "should not destroy carrier if has transport_orders" do
    assert @carrier.transport_orders.count > 0
    assert_difference('Carrier.count', 0) do
      delete :destroy, id: @carrier
    end

    assert_redirected_to carriers_path
  end
end
