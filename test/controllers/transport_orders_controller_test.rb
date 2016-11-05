require 'test_helper'

class TransportOrdersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @transport_order = transport_orders(:transport_order_one)
  end

  test "should get index" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:transport_orders)
  end

  test "should get new" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create transport_order" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('TransportOrder.count') do
      post :create, transport_order: {
        client_id: clients(:client_google).id,
        carrier_id: carriers(:carrier_one).id,
        seller_id: clients(:client_microsoft).id,
        route: "Polska - Niemcy",
        distance: "213",
        client_email: "karlososhd@gmail.com",
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

  test "should create transport_order_name" do
    sign_in users(:user_accountant)
    @request.env['HTTP_REFERER'] = 'http://groupone.lvh.me:3000/transport_orders'
    @request.host = "groupone.lvh.me:3000"
    transport_order = transport_orders(:transport_order_without_name)
    put :create_name, id: transport_order
    assert transport_order.transport_order_name.present?
  end

  test "should show transport_order" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :show, id: @transport_order
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @transport_order
    assert_response :success
  end

  test "should update transport_order" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    patch :update, id: @transport_order, transport_order: {
      client_id: clients(:client_google).id,
      carrier_id: carriers(:carrier_one).id,
      route: "Polska - Niemcy",
      distance: "213",
      client_email: "karlososhd@gmail.com",
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
    assert_redirected_to transport_order_path(assigns(:transport_order))
  end

  test "should destroy transport_order" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    @request.env['HTTP_REFERER'] = 'http://groupone.lvh.me:3000/transport_orders'
    assert_difference('TransportOrder.count', -1) do
      delete :destroy, id: @transport_order
    end

    assert_redirected_to transport_orders_path
  end
end
