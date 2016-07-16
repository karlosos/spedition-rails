require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = clients(:client_google)
  end

  test "Adress should not be nil" do
    @client.address = nil
    assert_not @client.valid?
  end

  test "Contact should not be nil" do
    @client.contact = nil
    assert_not @client.valid?
  end

  test "Name should be present" do
    @client.name = " "
    assert_not @client.valid?
  end

  test "Client should be valid" do
    assert @client.valid?
  end
end
