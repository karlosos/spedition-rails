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
