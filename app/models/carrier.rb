class Carrier < ActiveRecord::Base
  has_many :transport_orders, class_name: 'TransportOrder', foreign_key: 'carrier_id'
  has_one :address, as: :addressable, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact

  validates :registration_number, presence: true
  validates :size, presence: true
  validates :carrier_name, presence: true
  validates :carrier_email, presence: true
  validates :driver_name, presence: true
  validates :driver_email, presence: true

  before_destroy :check_for_transport_orders

  private

  def check_for_transport_orders
    if transport_orders.any?
      errors[:base] << 'Nie można usunąć samochodu który ma zlecenia'
      return false
    end
  end
end
