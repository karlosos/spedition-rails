require 'test_helper'

class InvoiceItemCorrectionTest < ActiveSupport::TestCase
  def setup
    @invoice_item = invoice_item_corrections(:invoice_item_correction_one)
  end

  test "tax_rate should be present" do
    assert @invoice_item.tax_rate.present?
    @invoice_item.tax_rate = nil
    assert_not @invoice_item.valid?
  end

  test "tax_rate_correction should be present" do
    assert @invoice_item.tax_rate_correction.present?
    @invoice_item.tax_rate_correction = nil
    assert_not @invoice_item.valid?
  end
end
