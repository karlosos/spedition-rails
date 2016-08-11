class TransportOrder < ActiveRecord::Base
  has_one :transport_order_name, :dependent => :destroy
  has_one :freichtage_description, :dependent => :destroy
  has_many :loading_places, inverse_of: :transport_order
  has_many :unloading_places, inverse_of: :transport_order

  belongs_to :carrier, class_name: "Carrier", foreign_key: "carrier_id"
  belongs_to :client, class_name:  "Client", foreign_key: "client_id"
  belongs_to :seller, class_name: "Client", foreign_key: "seller_id"

  monetize :freight_rate_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }

  monetize :profit_margin_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }

  accepts_nested_attributes_for :transport_order_name
  accepts_nested_attributes_for :freichtage_description
  accepts_nested_attributes_for :loading_places
  accepts_nested_attributes_for :unloading_places

  validates :transport_order_name, presence: true
  validates :carrier, presence: true
  validates :client, presence: true
  validates :route, presence: true
  validates :loading_places, :length => { :minimum => 1 }
  validates :unloading_places, :length => { :minimum => 1 }

  before_save do
    self.client_name = self.client.name
    self.client_street = self.client.address.street
    self.client_zip = self.client.address.zip
    self.client_city = self.client.address.city
    self.client_country = self.client.address.country
    self.client_email = self.client.contact.email
    self.client_phone = self.client.contact.phone1

    self.carrier_name = self.carrier.carrier_name
    self.carrier_driver_name = self.carrier.driver_name
    self.carrier_street = self.carrier.address.street
    self.carrier_zip = self.carrier.address.zip
    self.carrier_city = self.carrier.address.city
    self.carrier_country = self.carrier.address.country
    true
  end

  def loading_status_human
    if self.loading_status == true
      return "Wysłano"
    else
      return "Nie wysłano"
    end
  end

end
