class Invoice < ActiveRecord::Base
  has_one :invoice_name
  has_one :seller, :class_name => "Client", :foreign_key => "seller_id"
  has_one :client, :class_name => "Client", :foreign_key => "client_id"
  has_many :invoice_items
  has_many :items, through: :invoice_items
end
