class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :street, presence: true
  validates :city, presence: true
  validates :zip, presence: true
  validates :country, presence: true
end
