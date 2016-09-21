class Client < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member
  
  belongs_to :tax_rate
  has_one :address, as: :addressable, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy
  validates :address, presence: true
  validates :contact, presence: true
  validates :name, presence: true

  has_many :invoices_as_seller, class_name: 'Invoice', foreign_key: 'seller_id'
  has_many :invoices_as_client, class_name: 'Invoice', foreign_key: 'client_id'
  has_many :transport_orders, class_name: 'TransportOrder', foreign_key: 'client_id'
  has_many :emails, through: :contact

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact

  def debt
    debt = Money.new(0, 'EUR')
    invoices_as_client.each do |invoice|
      debt += invoice.total_selling_price if invoice.status < 3
    end
    debt
  end

  def self.search(search_params)
    name = search_params[:name]
    street = search_params[:street]
    city = search_params[:city]
    nip = search_params[:nip]

    @clients = Client.all

    if name.present?
      name = name.downcase
      @clients = @clients.where('lower(name) LIKE ?', "%#{name}%")
    end

    if street.present?
      street = street.downcase
      @clients = @clients.where('lower(addresses.street) LIKE ?', "%#{street}%")
    end

    if city.present?
      city = city.downcase
      @clients = @clients.where('lower(addresses.city) LIKE ?', "%#{city}%")
    end

    if nip.present?
      nip = nip.downcase
      @clients = @clients.where('lower(nip) LIKE ?', "%#{nip}%")
    end

    @clients
  end
end
