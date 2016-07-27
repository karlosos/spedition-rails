class TransportOrder < ActiveRecord::Base
  has_one :transport_order_name, :dependent => :destroy
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

  validates :transport_order_name, presence: true
  validates :carrier, presence: true
  validates :client, presence: true
  validates :loading_city, presence: true
  validates :loading_country, presence: true
  validates :loading_zip, presence: true
  validates :unloading_city, presence: true
  validates :unloading_country, presence: true
  validates :unloading_zip, presence: true
  validates :route, presence: true
end
