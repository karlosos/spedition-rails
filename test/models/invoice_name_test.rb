require 'test_helper'

class InvoiceNameTest < ActiveSupport::TestCase
  def setup
    @invoice_name = invoice_names(:name_invoice_one)
  end

  test "number should be present" do
    @invoice_name.number = nil
    assert_not @invoice_name.valid?
    @invoice_name.number = 20122
    assert @invoice_name.valid?
  end

  test "moth should be present" do
    @invoice_name.month = nil
    assert_not @invoice_name.valid?
    @invoice_name.month = 3
    assert @invoice_name.valid?
  end

  test "year should be present" do
    @invoice_name.year = nil
    assert_not @invoice_name.valid?
    @invoice_name.year = 2016
    assert @invoice_name.valid?
  end

  test "number should be greater than 0" do
    @invoice_name.number = -3
    assert_not @invoice_name.valid?
  end

  test "month should be greater than 0 and lesser than 13" do
    @invoice_name.month = 0
    assert_not @invoice_name.valid?

    @invoice_name.month = 13
    assert_not @invoice_name.valid?

    @invoice_name.month = 6
    assert @invoice_name.valid?
  end

  test "year should be greater than 0" do
    @invoice_name.year = -3
    assert_not @invoice_name.valid?
  end

  test "number/month/year should be unique" do
    @new_invoice_name = @invoice_name.dup
    assert_not @new_invoice_name.valid?
  end

  test "different number should be valid" do
    @new_invoice_name = @invoice_name.dup
    @new_invoice_name.number = @new_invoice_name.number + 1
    assert @new_invoice_name.valid?
  end

end
