require 'test_helper'

class TransportOrdersControllerTest < ActionController::TestCase
  setup do
    @transport_order = transport_orders(:transport_order_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transport_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport_order" do
    assert_difference('TransportOrder.count') do
      post :create, transport_order: {
        transport_order_name_attributes: {
          "number" => "2",
          "year" => "2016"
          },
        client_id: clients(:client_google).id,
        carrier_id: carriers(:carrier_one).id,
        route: "Polska - Niemcy",
        distance: "213",
        loading_places_attributes: 
        {
          "0" => {
            country: "Poland",
            city: "Szczecin",
            zip: "71-800"
          }
        },
        unloading_places_attributes: 
        {
          "0" => {
            country: "DE",
            city: "Munchen",
            zip: "DE0232103"
          }
        },
        freight_rate: "210.30",
      }
    end

    assert_redirected_to transport_order_path(assigns(:transport_order))
  end

  test "should show transport_order" do
    get :show, id: @transport_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transport_order
    assert_response :success
  end

  test "should update transport_order" do
    patch :update, id: @transport_order, transport_order: {
      transport_order_name_attributes: {
        "number" => "1",
        "year" => "2016"
        },
      client_id: clients(:client_google).id,
      carrier_id: carriers(:carrier_one).id,
      route: "Polska - Niemcy",
      distance: "213",
      freight_rate: "210.30",
      loading_country: "PL",
      loading_zip: "71-800",
      loading_city: "Szczecin",
      loading_date: "2016-07-26",
      unloading_country: "DE",
      unloading_zip: "DE0232103",
      unloading_city: "Munchen",
      unloading_date: "2016-07-26"
    }
    assert_redirected_to transport_order_path(assigns(:transport_order))
  end

  test "should destroy transport_order" do
    assert_difference('TransportOrder.count', -1) do
      delete :destroy, id: @transport_order
    end

    assert_redirected_to transport_orders_path
  end
end
