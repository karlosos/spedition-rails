class TransportOrder < ActiveRecord::Base
  has_one :transport_order_name, :dependent => :destroy
  belongs_to :carrier, class_name: "Carrier", foreign_key: "carrier_id"
  belongs_to :client, class_name:  "Client", foreign_key: "client_id"

  monetize :freight_rate_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
end
