class InvoiceItem < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :invoice
  belongs_to :item

  validates_presence_of :invoice
  validates_presence_of :item
  validates_presence_of :quantity
  validates_presence_of :unit_price_cents
  validates_presence_of :unit_price_currency
  validates_presence_of :value_added_tax_cents
  validates_presence_of :value_added_tax_currency
  validates_presence_of :net_price_cents
  validates_presence_of :net_price_currency
  validates_presence_of :total_selling_price_cents
  validates_presence_of :total_selling_price_currency

  validates_with InvoiceItemPriceValidator

  monetize :unit_price_cents, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :value_added_tax_cents, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :net_price_cents, numericality: {
    greater_than_or_equal_to: 0
  }
  monetize :total_selling_price_cents, numericality: {
    greater_than_or_equal_to: 0
  }

  accepts_nested_attributes_for :item
end
