require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:invoice_one)

    @invoice_params = {
        date: "2016-07-07",
        invoice_name_attributes: {
          "number"=>"9",
          "month"=>"7",
          "year"=>"2016"
        },
        place: "Szczecin",
        seller_id: clients(:client_google).id,
        client_id: clients(:client_microsoft).id,
        client_name: "Nazwa",
        client_street: "Ulica",
        client_zip: "23-232",
        client_city: "Miasto",
        client_country: "Polska",
        client_email: "test@example.pl",
        client_phone: "732-320-322",
        invoice_items_attributes:
        {
          "0" => {
            item_id: items(:item_one).id,
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
        currency_rate: "4.4469",
        invoice_exchange_currency: "PLN",
        invoice_language: "PL"
      }
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
      post :create, invoice: @invoice_params
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should update client on invoice client params change" do
    @invoice_params[:client_name] = "New name"
    @invoice_params[:client_street] = "New street"
    @invoice_params[:client_zip] = "New zip"
    @invoice_params[:client_city] = "New city"
    @invoice_params[:client_country] = "New country"
    @invoice_params[:client_email] = "New email"
    @invoice_params[:client_phone] = "New phone"

    assert_difference('Invoice.count') do
      post :create, invoice: @invoice_params
    end

    assert_equal(@invoice.client.name, @invoice_params[:client_name])
    assert_equal(@invoice.client.address.street, @invoice_params[:client_street])
    assert_equal(@invoice.client.address.zip, @invoice_params[:client_zip])
    assert_equal(@invoice.client.address.city, @invoice_params[:client_city])
    assert_equal(@invoice.client.address.country, @invoice_params[:client_country])
    assert_equal(@invoice.client.contact.email, @invoice_params[:client_email])
    assert_equal(@invoice.client.contact.phone1, @invoice_params[:client_phone])
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
