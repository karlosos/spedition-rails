class Client < ActiveRecord::Base
  has_one :address, :as => :addressable
  has_one :contact, :as => :contactable
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact
  validates :address, presence: true
  validates :contact, presence: true

  has_many :invoices_as_seller,    class_name: 'Invoice', foreign_key: 'seller_id'
  has_many :ivoices_as_buyer, class_name: 'Invoice', foreign_key: 'buyer_id'

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

end
