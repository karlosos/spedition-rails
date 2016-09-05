class InvoiceItemCorrection < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item
  belongs_to :tax_rate, class_name: 'TaxRate', foreign_key: 'tax_rate_id'
  belongs_to :tax_rate_correction, class_name:  'TaxRate', foreign_key: 'tax_rate_correction_id'

  validates_presence_of :tax_rate
  validates_presence_of :tax_rate_correction
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

  monetize :unit_price_cents
  monetize :unit_price_correction_cents
  monetize :unit_price_difference_cents
  monetize :value_added_tax_cents
  monetize :value_added_tax_correction_cents
  monetize :value_added_tax_difference_cents
  monetize :net_price_cents
  monetize :net_price_correction_cents
  monetize :net_price_difference_cents
  monetize :total_selling_price_cents
  monetize :total_selling_price_correction_cents
  monetize :total_selling_price_difference_cents
end
