class Invoice < ActiveRecord::Base
  has_one :invoice_name, :dependent => :destroy
  belongs_to :seller, class_name: "Client", foreign_key: "seller_id"
  belongs_to :client, class_name:  "Client", foreign_key: "client_id"
  has_many :invoice_items, inverse_of: :invoice
  has_many :items, through: :invoice_items

  monetize :value_added_tax_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :net_price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }
  monetize :total_selling_price_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }

  #accepts_nested_attributes_for :client
  #accepts_nested_attributes_for :seller
  accepts_nested_attributes_for :invoice_name
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  validates :client, presence: true
  validates :seller, presence: true
  validates :invoice_name, presence: true
  validates :date, presence: true
  validates :invoice_items, :length => { :minimum => 1 }

  def self.search(search_params)
    date = ""
    client_name = ""
    if search_params[:date]
      date = search_params[:date]
    end
    if search_params[:client_name]
      client_name = search_params[:client_name]
    end

    where('date LIKE ? AND clients.name LIKE ? ', "%#{date}%", "%#{client_name}%")
  end
end
