class Carrier < ActiveRecord::Base
  has_many :transport_orders, class_name: 'TransportOrder', foreign_key: 'carrier_id'
end
