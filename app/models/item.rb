class Item < ActiveRecord::Base
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  monetize :price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :unit_price_cents
  validates :name, presence: true
  validates :quantity, presence: true
  validates :unit, presence: true

  before_save :update_price

  private
  def update_price
    unit_price = self.unit_price
    quantity = self.quantity
    self.price = unit_price * quantity
  end
end
