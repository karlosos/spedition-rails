class Item < ActiveRecord::Base
  belongs_to :transport_order
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  monetize :unit_price_cents, numericality: {
    greater_than_or_equal_to: 0
  }

  validates :name, presence: true
  validates :unit, presence: true
end
