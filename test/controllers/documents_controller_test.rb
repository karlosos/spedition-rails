require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @document = documents(:document_one)
  end

  test "should get index" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
  end

  test "should get new" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  # Korzysta z api google
  # test "should get create" do
  #   sign_in users(:user_speditor)
  #   @request.host = "groupone.lvh.me:3000"
  #   assert_difference('Document.count') do
  #     post :create, document: {
  #       name: "Dokument 1",
  #       transport_order_id: transport_orders(:transport_order_one).id,
  #       file_id: "FileIDFromGDrive",
  #       web_content_link: "WebContentLinkFromGDrive"
  #     }
  #   end
  #
  #   assert_redirected_to carrier_path(assigns(:carrier))
  # end

  test "should destroy" do
    sign_in users(:user_speditor)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Document.count', -1) do
      delete :destroy, id: @document
    end
  end

end
