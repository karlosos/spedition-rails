class Item < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member
  
  belongs_to :transport_order
  belongs_to :tax_rate
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  monetize :unit_price_cents, numericality: {
    greater_than_or_equal_to: 0
  }

  validates_presence_of :tax_rate
  validates :name, presence: true
  validates :unit, presence: true
end
