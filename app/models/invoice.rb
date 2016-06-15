class Invoice < ActiveRecord::Base
  has_one :invoice_name
  belongs_to :seller, class_name: "Client", foreign_key: "seller_id"
  belongs_to :client, class_name:  "Client", foreign_key: "client_id"
  has_many :invoice_items, inverse_of: :invoice
  has_many :items, through: :invoice_items

  #accepts_nested_attributes_for :client
  #accepts_nested_attributes_for :seller
  accepts_nested_attributes_for :invoice_name
  accepts_nested_attributes_for :invoice_items

  validates :client, presence: true
  validates :seller, presence: true
  validates :invoice_name, presence: true
  validates :date, presence: true
  validates :invoice_items, :length => { :minimum => 1 }
end
