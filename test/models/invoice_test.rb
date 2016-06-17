require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @item1 = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax: nil, unit_price_cents: Money.new(62700, 'EUR'))
    @item2 = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax: nil, unit_price_cents: Money.new(43827, 'EUR'))
    @invoice_item1 = InvoiceItem.new(item: @item1, quantity: 2)
    @invoice_item2 = InvoiceItem.new(item: @item2, quantity: 4)
    @address = Address.new(line1: "ul. Cicha 132 m.16", city: "Gniezno", zip: "62-200", country: "Polska")
    @contact = Contact.new()
    @client = Client.new(name: "Company A", address: @address, contact: @contact)
    @seller = Client.new(name: "Company B", address: @address, contact: @contact)
    @invoice_name = InvoiceName.new(number: 1, month: 3, year: 2016)

    @item1.save
    @item2.save
    @address.save
    @client.save
    @seller.save
    @invoice_name.save

    @invoice = Invoice.new(date: DateTime.now)
    @invoice.invoice_name = @invoice_name
    @invoice.client = @client
    @invoice.seller = @seller
    @invoice.invoice_items << @invoice_item1
    @invoice.invoice_items << @invoice_item2
  end

  test "client should be present" do
    @invoice.client = nil
    assert_not @invoice.valid?
  end

  test "seller should be present" do
    @invoice.seller = nil
    assert_not @invoice.valid?
  end

  test "invoice_name should be present" do
    @invoice.invoice_name = nil
    assert_not @invoice.valid?
  end

  test "date should be present" do
    @invoice.date = nil
    assert_not @invoice.valid?
  end

  test "at least one invoice_item should be present" do
    @invoice.invoice_items.each do |invoice_item|
      @invoice.invoice_items.delete(invoice_item)
    end
    assert_equal 0, @invoice.invoice_items.size
    assert_not @invoice.valid?
  end
end