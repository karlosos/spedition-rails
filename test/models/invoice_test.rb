require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @invoice = invoices(:invoice_one)
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
    assert @invoice.invoice_name.get_name.present?
    @invoice.invoice_name = nil
    assert_not @invoice.valid?
  end

  test "date should be present" do
    assert @invoice.date.present?
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

  test "at least one item should be present" do
    @invoice.items.each do |item|
      @invoice.items.delete(item)
    end
    assert_equal 0, @invoice.items.size
    assert_not @invoice.valid?
  end

  test "value_added_tax_cents must be present" do
    @invoice.value_added_tax_cents = nil
    assert_not @invoice.valid?
  end

  test "net_price_cents must be present" do
    @invoice.net_price_cents = nil
    assert_not @invoice.valid?
  end

  test "total_selling_price_cents must be present" do
    @invoice.total_selling_price_cents = nil
    assert_not @invoice.valid?
  end

  test "invoice net price should be equal to sum of all invoice_items net prices" do
    assert @invoice.invoice_items.size > 0
    net_price = @invoice.net_price
    sum_net_price = Money.new(0, 'EUR')
    @invoice.invoice_items.each do |invoice_item|
      sum_net_price += invoice_item.net_price
    end
    assert_equal net_price, sum_net_price
  end

  test "invoice value added tax should be equal to sum of all invoice_items vap" do
    assert @invoice.invoice_items.size > 0
    value_added_tax = @invoice.value_added_tax
    sum_value_added_tax = Money.new(0, 'EUR')
    @invoice.invoice_items.each do |invoice_item|
      sum_value_added_tax += invoice_item.value_added_tax
    end
    assert_equal value_added_tax, sum_value_added_tax
  end

  test "invoice total price should be equal to sum of all invoice_items total price" do
    assert @invoice.invoice_items.size > 0
    total_selling_price = @invoice.total_selling_price
    sum_total_selling_price = Money.new(0, 'EUR')
    @invoice.invoice_items.each do |invoice_item|
      sum_total_selling_price += invoice_item.total_selling_price
    end
    assert_equal sum_total_selling_price, total_selling_price
  end

  test "client_street should be present" do
    @invoice.client_street = " "
    assert_not @invoice.valid?
  end

  test "client_name should be present" do
    @invoice.client_name = ""
    assert_not @invoice.valid?
  end

  test "client_zip should be present" do
    @invoice.client_zip = " "
    assert_not @invoice.valid?
  end

  test "client_city should be present" do
    @invoice.client_city = " "
    assert_not @invoice.valid?
  end

  test "client_country should be present" do
    @invoice.client_country = " "
    assert_not @invoice.valid?
  end

  test "client_phone doesn't need to be present" do
    @invoice.client_phone = " "
    assert @invoice.valid?
  end

  test "client_email doesn't need to be present" do
    @invoice.client_email = " "
    assert @invoice.valid?
  end

  test "place should be present" do
    @invoice.place = " "
    assert_not @invoice.valid?
  end

  test "currency_rate_table_name should be present if other currency" do
    @invoice.currency_rate_table_name = " "
    assert_not @invoice.valid?
  end

  test "currency_rate should be present if other currency" do
    @invoice.currency_rate = " "
    assert_not @invoice.valid?
  end

  test "currency_rate_name should be present if other currency" do
    @invoice.currency_rate_name = " "
    assert_not @invoice.valid?
  end

  test "status should be present" do
    @invoice.status = nil
    assert_not @invoice.valid?
  end

  test "total price in words should be present" do
    @invoice.total_price_in_words = " "
    assert_not @invoice.valid?
  end

  test "deadline should be present" do
    @invoice.deadline = nil
    assert_not @invoice.valid?
  end

  test "should return valid debt" do
    assert_equal(@invoice.total_selling_price, @invoice.client.debt)
  end
end
