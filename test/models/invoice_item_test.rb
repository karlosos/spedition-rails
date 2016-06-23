require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def setup
    @item1 = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax: nil, unit_price_cents: Money.new(62700, 'EUR'))
    @item2 = Item.new(name: "Transport na trasie A-B", unit: "FRACHT", tax: nil, unit_price_cents: Money.new(43827, 'EUR'))
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
    @invoice_item = InvoiceItem.new(quantity: 3, item: @item1)
    @invoice_item2 = InvoiceItem.new(quantity: 4, item: @item2)
    @invoice.invoice_items << @invoice_item
    @invoice.invoice_items << @invoice_item2
  end

  # test "price should be updated after update" do
  #   money = Money.new(100, 'EUR')
  #   quantity = 4
  #   @invoice_item.unit_price = money
  #   @invoice_item.quantity = quantity
  #   @invoice_item.save
  #   assert_equal money * quantity, @invoice_item.price
  # end
end
