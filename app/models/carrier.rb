class Carrier < ActiveRecord::Base
  has_many :transport_orders, class_name: 'TransportOrder', foreign_key: 'carrier_id'

  validates :registration_number, presence: true
  validates :size, presence: true
  validates :carrier_name, presence: true
  validates :carrier_email, presence: true
  validates :driver_name, presence: true
  validates :driver_email, presence: true
end
