class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item

  validates_presence_of :invoice
  validates_presence_of :item
  validates_presence_of :quantity
  validates_presence_of :price_cents
  validates_presence_of :price_currency

  monetize :price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :unit_price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :value_added_tax_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :net_price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :total_selling_price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  
  accepts_nested_attributes_for :item

  before_save :update_price

  private
  def update_price
    unit_price = self.unit_price
    quantity = self.quantity
    self.price = unit_price * quantity
  end
end
