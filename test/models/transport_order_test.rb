require 'test_helper'

class TransportOrderTest < ActiveSupport::TestCase
  def setup
    @transport_order = transport_orders(:transport_order_one)
  end

  # test "transport_order_name should be present" do
  #   assert @transport_order.transport_order_name.get_name.present?
  #   @transport_order.transport_order_name = nil
  #   assert_not @transport_order.valid?
  # end

  test "carrier should be present" do
    assert @transport_order.carrier.present?
    @transport_order.carrier = nil
    assert_not @transport_order.valid?
  end

  test "client should be present" do
    assert @transport_order.client.present?
    @transport_order.client = nil
    assert_not @transport_order.valid?
  end

  test "route should be present" do
    assert @transport_order.route.present?
    @transport_order.route = nil
    assert_not @transport_order.valid?
  end

  test "at least one loading_place should be present" do
    @transport_order.loading_places.each do |loading_places|
      @transport_order.loading_places.delete(loading_places)
    end
    assert_equal 0, @transport_order.loading_places.size
    assert_not @transport_order.valid?
  end

  test "at least one unloading_place should be present" do
    @transport_order.unloading_places.each do |unloading_place|
      @transport_order.unloading_places.delete(unloading_place)
    end
    assert_equal 0, @transport_order.unloading_places.size
    assert_not @transport_order.valid?
  end

  test "client name should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_name, @transport_order.client.name

    @client.name = "New client name"
    @client.save
    assert_not_equal @transport_order.client_name, @transport_order.client.name
  end

  test "client nip should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_nip, @transport_order.client.nip

    @client.nip = "New client nip"
    @client.save
    assert_not_equal @transport_order.client_nip, @transport_order.client.nip
  end

  test "client street should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_street, @transport_order.client.address.street

    @client.address.street = "New client street"
    @client.save
    assert_not_equal @transport_order.client_street, @transport_order.client.address.street
  end

  test "client zip should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_zip, @transport_order.client.address.zip

    @client.address.zip = "New client zip"
    @client.save
    assert_not_equal @transport_order.client_zip, @transport_order.client.address.zip
  end

  test "client city should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_city, @transport_order.client.address.city

    @client.address.city = "New client city"
    @client.save
    assert_not_equal @transport_order.client_city, @transport_order.client.address.city
  end

  test "client country should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_country, @transport_order.client.address.country

    @client.address.country = "New client country"
    @client.save
    assert_not_equal @transport_order.client_country, @transport_order.client.address.country
  end

  test "client phone should be fixed" do
    @client = clients(:client_microsoft)
    @transport_order.client = @client
    @transport_order.save
    assert_equal @transport_order.client_phone, @transport_order.client.contact.phone1

    @client.contact.phone1 = "New client phone"
    @client.save
    assert_not_equal @transport_order.client_phone, @transport_order.client.contact.phone1
  end

  test "carrier name should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_name, @transport_order.carrier.client.name

    @carrier.client.name = "New carrier name"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_name, @transport_order.carrier.client.name
  end

  test "carrier nip should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_nip, @transport_order.carrier.client.nip

    @carrier.client.nip = "New carrier nip"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_nip, @transport_order.carrier.client.nip
  end

  test "carrier driver name should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_driver_name, @transport_order.carrier.driver_name

    @carrier.driver_name = "New carrier nip"
    @carrier.save
    assert_not_equal @transport_order.carrier_driver_name, @transport_order.carrier.driver_name
  end

  test "carrier street should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_street, @transport_order.carrier.client.address.street

    @carrier.client.address.street = "New carrier street"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_street, @transport_order.carrier.client.address.street
  end

  test "carrier zip should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_zip, @transport_order.carrier.client.address.zip

    @carrier.client.address.zip = "New carrier zip"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_zip, @transport_order.carrier.client.address.zip
  end

  test "carrier city should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save
    assert_equal @transport_order.carrier_city, @transport_order.carrier.client.address.city

    @carrier.client.address.city = "New carrier city"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_city, @transport_order.carrier.client.address.city
  end

  test "carrier country should be fixed" do
    @carrier = carriers(:carrier_one)
    @transport_order.carrier = @carrier
    @transport_order.save

    assert_equal @transport_order.carrier_country, @transport_order.carrier.client.address.country

    @carrier.client.address.country = "New carrier country"
    @carrier.client.save
    assert_not_equal @transport_order.carrier_country, @transport_order.carrier.client.address.country
  end
end
