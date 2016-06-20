require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:invoice_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create invoice" do
  #   assert_difference('Invoice.count') do
  #     post :create, invoice: { "date"=>"2016-06-21",
  #       "invoice_name_attributes"=>
  #           {
  #             "number"=>"3",
  #             "month"=>"6",
  #             "year"=>"2016"
  #           },
  #       "client_id"=>"1",
  #       "seller_id"=>"1",
  #       "invoice_items_attributes"=>
  #         {
  #           "0"=>{"item_id"=>"1",
  #             "quantity"=>"1",
  #             "unit_price"=>"320.3",
  #             "_destroy"=>"false"
  #             }
  #         }
  #     }
  #   end
  #
  #   assert_redirected_to invoice_path(assigns(:invoice))
  # end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  # test "should update invoice" do
  #   patch :update, id: @invoice, invoice: {}
  #
  #   assert_redirected_to invoice_path(assigns(:invoice))
  # end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
