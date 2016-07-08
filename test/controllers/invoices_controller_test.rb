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

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: {
          date: "2016-07-07",
          invoice_name_attributes: {
            "number"=>"9",
            "month"=>"7",
            "year"=>"2016"
          },
          place: "Szczecin",
          seller_id: "2",
          client_id:"2",
          client_street: "ehehh",
          client_zip: "hehehh",
          client_city: "eheh",
          client_country: "heheh",
          client_email: "hhehe",
          client_phone: "ehhehe",
          invoice_items_attributes:
          {
            "0" => {
              item_id: "2",
              quantity: "1",
              unit_price: "1.30",
              tax_rate: "23",
              net_price: "1.30",
              value_added_tax: "0.30",
              total_selling_price: "1.60",
              _destroy: "false"
            }
          },
          net_price: "1.30",
          value_added_tax: "0.30",
          total_selling_price: "1.60",
          total_price_in_words: "jeden euro 60/100",
          currency_rate_table_name: "129/A/NBP/2016",
          currency_rate_name: "EUR",
          currency_rate: "4.4469"
        }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    Money.add_rate("EUR", "PLN", @invoice.currency_rate)
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
