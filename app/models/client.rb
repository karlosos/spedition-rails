class Client < ActiveRecord::Base
  has_one :address, :as => :addressable, :dependent => :destroy
  has_one :contact, :as => :contactable, :dependent => :destroy
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact
  validates :address, presence: true
  validates :contact, presence: true
  validates :name, presence: true

  has_many :invoices_as_seller,    class_name: 'Invoice', foreign_key: 'seller_id'
  has_many :invoices_as_client, class_name: 'Invoice', foreign_key: 'client_id'
  has_many :transport_orders, class_name: 'TransportOrder', foreign_key: 'client_id'
  has_many :emails, through: :contact

  def debt
    debt = Money.new(0, 'EUR')
    self.invoices_as_client.each do |invoice|
      if invoice.status < 3
        debt += invoice.total_selling_price
      end
    end
    return debt
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

    return @clients
  end

end
