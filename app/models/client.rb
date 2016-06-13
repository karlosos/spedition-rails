class Client < ActiveRecord::Base
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :address
  validates :address, presence: true
end
