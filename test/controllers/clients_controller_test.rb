require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @client = clients(:client_google)
  end

  test "should get index" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should create client" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Client.count') do
      post :create, client: { name: "Company A", address_attributes: { street: "ul. Cicha 21", city: "Gniezno", country: "Polska", zip: "23-023" }, contact_attributes: {
        emails_attributes: {"0"=>{"address"=>"Email1"}}
        } }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    patch :update, id: @client, client: { name: "Company A", address_attributes: { street: "ul. Cicha 21", city: "Gniezno", country: "Polska", zip: "23-023" }, contact_attributes: {
      emails_attributes: {"0"=>{"address"=>"Email1"}}} }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
