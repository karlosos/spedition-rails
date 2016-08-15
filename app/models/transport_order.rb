class TransportOrder < ActiveRecord::Base
  has_one :transport_order_name, :dependent => :destroy
  has_one :freichtage_description, :dependent => :destroy
  has_many :loading_places, inverse_of: :transport_order
  has_many :unloading_places, inverse_of: :transport_order

  belongs_to :carrier, class_name: "Carrier", foreign_key: "carrier_id"
  belongs_to :client, class_name:  "Client", foreign_key: "client_id"
  belongs_to :seller, class_name: "Client", foreign_key: "seller_id"

  monetize :freight_rate_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }

  monetize :profit_margin_cents, :numericality => {
    :greater_than_or_equal_to => 0
  }

  accepts_nested_attributes_for :transport_order_name
  accepts_nested_attributes_for :freichtage_description
  accepts_nested_attributes_for :loading_places
  accepts_nested_attributes_for :unloading_places

  validates :transport_order_name, presence: true
  validates :carrier, presence: true
  validates :client, presence: true
  validates :route, presence: true
  validates :loading_places, :length => { :minimum => 1 }
  validates :unloading_places, :length => { :minimum => 1 }

  before_save do
    self.client_name = self.client.name
    self.client_street = self.client.address.street
    self.client_zip = self.client.address.zip
    self.client_city = self.client.address.city
    self.client_country = self.client.address.country
    self.client_email = self.client.contact.email
    self.client_phone = self.client.contact.phone1

    self.carrier_name = self.carrier.carrier_name
    self.carrier_driver_name = self.carrier.driver_name
    self.carrier_street = self.carrier.address.street
    self.carrier_zip = self.carrier.address.zip
    self.carrier_city = self.carrier.address.city
    self.carrier_country = self.carrier.address.country
    true
  end

  def loading_status_human
    if self.loading_status == true
      return "Wysłano"
    else
      return "Nie wysłano"
    end
  end

  def self.search(search_params)
    name_number = search_params[:transport_order_name_number]
    name_year = search_params[:transport_order_name_year]
    freichtage_rate = search_params[:freight_rate_cents]
    if freichtage_rate.present?
      freichtage_rate = freichtage_rate.to_f * 100
    end
    zip = search_params[:zip]
    if zip
      zip = zip.downcase
    end
    city = search_params[:city]
    if city
      city = city.downcase
    end
    client_name = search_params[:client_name]
    if client_name
      client_name = client_name.downcase
    end
    client_id = search_params[:client_id]
    carrier_name = search_params[:carrier_name]
    if carrier_name
      carrier_name = carrier_name.downcase
    end
    driver_name = search_params[:driver_name]
    if driver_name
      driver_name = driver_name.downcase
    end
    registration_number = search_params[:registration_number]
    if registration_number
      registration_number = registration_number.downcase
    end
    loading_date = search_params[:loading_date]
    unloading_date = search_params[:unloading_date]
    loading_statuses = search_params[:loading_statuses]
    loading_date_start = search_params[:loading_date_start]
    loading_date_stop = search_params[:loading_date_stop]
    unloading_date_start = search_params[:unloading_date_start]
    unloading_date_stop = search_params[:unloading_date_stop]
    loading_statuses = search_params[:loading_statuses]

    @transport_orders = TransportOrder.all

    if name_number.present?
      @transport_orders = @transport_orders.where('transport_order_names.number = ?', name_number)
    end

    if name_year.present?
      @transport_orders = @transport_orders.where('transport_order_names.year = ?', name_year)
    end

    if freichtage_rate.present?
      @transport_orders = @transport_orders.where('freight_rate_cents = ?', freichtage_rate)
    end

    if zip.present?
      @transport_orders = @transport_orders.where('lower(loading_places.zip) LIKE ? OR lower(unloading_places.zip) LIKE ?', "%#{zip}%", "%#{zip}%")
    end

    if city.present?
      @transport_orders = @transport_orders.where('lower(loading_places.city) LIKE ? OR lower(unloading_places.city) LIKE ?', "%#{city}%", "%#{city}%")
    end

    if client_name.present?
      @transport_orders = @transport_orders.where('lower(client_name) LIKE ?', "%#{client_name}%")
    end

    if client_id.present?
      @transport_orders = @transport_orders.where('clients.id = ?', client_id)
    end

    if carrier_name.present?
      @transport_orders = @transport_orders.where('lower(TransportOrders.carrier_name) LIKE ?', "%#{carrier_name}%")
    end

    if driver_name.present?
      @transport_orders = @transport_orders.where('lower(driver_name) LIKE ?', "%#{driver_name}%")
    end

    if registration_number.present?
      @transport_orders = @transport_orders.where('lower(registration_number) LIKE ?', "%#{registration_number}%")
    end

    if loading_date_stop.present? && loading_date_start.present?
      @transport_orders = @transport_orders.where('loading_places.date >= ? AND loading_places.date <= ? ', loading_date_start.to_datetime, loading_date_stop.to_datetime)
    elsif loading_date_start.present?
      @transport_orders = @transport_orders.where('loading_places.date >= ?', loading_date_start.to_datetime)
    elsif loading_date_stop.present?
      @transport_orders = @transport_orders.where('loading_places.date <= ?', loading_date_stop.to_datetime)
    end

    if unloading_date_stop.present? && unloading_date_start.present?
      @transport_orders = @transport_orders.where('unloading_places.date >= ? AND unloading_places.date <= ? ', unloading_date_start.to_datetime, unloading_date_stop.to_datetime)
    elsif unloading_date_start.present?
      @transport_orders = @transport_orders.where('unloading_places.date >= ?', unloading_date_start.to_datetime)
    elsif loading_date_stop.present?
      @transport_orders = @transport_orders.where('unloading_places.date <= ?', loading_date_stop.to_datetime)
    end

    if loading_date.present?
      @transport_orders = @transport_orders.where('loading_places.date = ?', loading_date.to_datetime)
    end

    if unloading_date.present?
      @transport_orders = @transport_orders.where('unloading_places.date = ?', unloading_date.to_datetime)
    end

    if loading_statuses
      @transport_orders = @transport_orders.where('loading_status = ?', loading_statuses)
    end

    return @transport_orders.order('transport_order_names.year DESC, transport_order_names.number DESC')
  end
end
