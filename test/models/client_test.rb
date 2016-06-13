require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @address = Address.new(line1: "ul. Cicha 132 m.16", city: "Gniezno", zip: "62-200", country: "Polska")
    @client = Client.new(name: "Company A", address: @address)
  end

  test "Adress should not be nil" do
    @client.address = nil
    assert_not @client.valid?
  end
end
