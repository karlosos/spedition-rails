class LoadingPlace < ActiveRecord::Base
  belongs_to :transport_order

  validates_presence_of :city
  validates_presence_of :country
  validates_presence_of :zip
end
