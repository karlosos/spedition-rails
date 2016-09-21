require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @invoice = invoices(:invoice_one)

    @invoice_params = {
        kind: 'vat',
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
            tax_rate_id: tax_rates(:tax_rate_one).id,
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
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    get :new
    assert_response :success
  end

  test "should get new_correction" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    get :new_correction, :id => invoices(:invoice_one)
    assert_response :success
    @invoice = assigns(:invoice)
    assert_equal @invoice.kind, 'correction'
    assert_equal @invoice.invoice_to_correct_id, invoices(:invoice_one).id
    assert_equal @invoice.client, invoices(:invoice_one).client
    assert_equal @invoice.seller, invoices(:invoice_one).seller
    assert_equal @invoice.client_name, invoices(:invoice_one).client_name
    assert_equal @invoice.client_street, invoices(:invoice_one).client_street
    assert_equal @invoice.client_zip, invoices(:invoice_one).client_zip
    assert_equal @invoice.client_city, invoices(:invoice_one).client_city
    assert_equal @invoice.client_country, invoices(:invoice_one).client_country
    assert_equal @invoice.client_email, invoices(:invoice_one).client_email
    assert_equal @invoice.client_phone, invoices(:invoice_one).client_phone
    assert_equal @invoice.client_nip, invoices(:invoice_one).client_nip

    assert_equal @invoice.currency_rate, invoices(:invoice_one).currency_rate
    assert_equal @invoice.currency_rate_table_name, invoices(:invoice_one).currency_rate_table_name
    assert_equal @invoice.currency_rate_date, invoices(:invoice_one).currency_rate_date

    invoices(:invoice_one).invoice_items.each_with_index do |invoice_item, index|
      assert_equal @invoice.invoice_item_corrections[index].item, invoice_item.item
      assert_equal @invoice.invoice_item_corrections[index].item_name, invoice_item.item.name
      assert_equal @invoice.invoice_item_corrections[index].item_name_correction, invoice_item.item.name
      assert_equal @invoice.invoice_item_corrections[index].quantity, invoice_item.quantity
      assert_equal @invoice.invoice_item_corrections[index].quantity_correction, invoice_item.quantity
      assert_equal @invoice.invoice_item_corrections[index].quantity_difference, 0
      assert_equal @invoice.invoice_item_corrections[index].tax_rate, invoice_item.tax_rate
      assert_equal @invoice.invoice_item_corrections[index].tax_rate_correction, invoice_item.tax_rate
      assert_equal @invoice.invoice_item_corrections[index].unit_price, invoice_item.unit_price
      assert_equal @invoice.invoice_item_corrections[index].unit_price_correction, invoice_item.unit_price
      assert_equal @invoice.invoice_item_corrections[index].unit_price_difference, Money.new(0)
      assert_equal @invoice.invoice_item_corrections[index].value_added_tax, invoice_item.value_added_tax
      assert_equal @invoice.invoice_item_corrections[index].value_added_tax_correction, invoice_item.value_added_tax
      assert_equal @invoice.invoice_item_corrections[index].value_added_tax_difference, Money.new(0)
      assert_equal @invoice.invoice_item_corrections[index].net_price, invoice_item.net_price
      assert_equal @invoice.invoice_item_corrections[index].net_price_correction, invoice_item.net_price
      assert_equal @invoice.invoice_item_corrections[index].net_price_difference, Money.new(0)
      assert_equal @invoice.invoice_item_corrections[index].total_selling_price, invoice_item.total_selling_price
      assert_equal @invoice.invoice_item_corrections[index].total_selling_price_correction, invoice_item.total_selling_price
      assert_equal @invoice.invoice_item_corrections[index].total_selling_price_difference, Money.new(0)
    end
  end

  test "should get new_invoice_from_transport_orders" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    transport_order = transport_orders(:transport_order_one)
    transport_order_ids = [transport_order,]
    get :new_invoice_from_transport_orders, :transport_order_ids => transport_order_ids
    assert_response :success
    @invoice = assigns(:invoice)
    assert_equal @invoice.kind, 'vat'
    assert_equal @invoice.client_id, transport_order.client_id
    assert_equal @invoice.seller_id, transport_order.seller_id
    assert_equal @invoice.client_name, transport_order.client_name
    assert_equal @invoice.client_street, transport_order.client_street
    assert_equal @invoice.client_zip, transport_order.client_zip
    assert_equal @invoice.client_nip, transport_order.client_nip
    assert_equal @invoice.client_city, transport_order.client_city
    assert_equal @invoice.sell_date, transport_order.unloading_places.last.date
  end

  test "should create invoice" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Invoice.count') do
      post :create, invoice: @invoice_params
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should update client on invoice client params change" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
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
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    Money.add_rate("EUR", "PLN", @invoice.currency_rate)
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    get :edit, id: @invoice
    assert_response :success
  end

  # test "should update invoice" do
  #   patch :update, id: @invoice, invoice: {}
  #
  #   assert_redirected_to invoice_path(assigns(:invoice))
  # end

  test "should destroy invoice" do
    sign_in users(:user_accountant)
    @request.host = "groupone.lvh.me:3000"
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
