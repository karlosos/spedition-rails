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

  def self.search(search_params)
    registration_number = search_params[:registration_number]
    carrier_name = search_params[:carrier_name]
    driver_name = search_params[:driver_name]

    @carriers = Carrier.all

    if registration_number.present?
      registration_number = registration_number.downcase
      @carriers = @carriers.where('lower(registration_number) LIKE ?', "%#{registration_number}%")
    end

    if carrier_name.present?
      carrier_name = carrier_name.downcase
      @carriers = @carriers.where('lower(carrier_name) LIKE ?', "%#{carrier_name}%")
    end

    if driver_name.present?
      driver_name = driver_name.downcase
      @carriers = @carriers.where('lower(driver_name) LIKE ?', "%#{driver_name}%")
    end

    @carriers
  end
end
