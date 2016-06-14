class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item

  validates_presence_of :invoice
  validates_presence_of :item

  accepts_nested_attributes_for :item
end
