require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def setup
    @invoice = invoices(:invoice_one)
    @invoice_item = @invoice.invoice_items.first
  end

  test "item should be present" do
    assert @invoice_item.item.present?
    @invoice_item.item = nil
    assert_not @invoice_item.valid?
  end
end
