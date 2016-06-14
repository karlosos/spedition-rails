class Client < ActiveRecord::Base
  has_one :address, :as => :addressable
  has_one :contact, :as => :contactable
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact
  validates :address, presence: true
  validates :contact, presence: true
end
