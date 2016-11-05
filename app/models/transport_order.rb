class TransportOrder < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member

  belongs_to :invoice
  has_one :item
  has_one :transport_order_name, dependent: :destroy
  has_one :freichtage_description, dependent: :destroy
  has_many :loading_places, inverse_of: :transport_order
  has_many :unloading_places, inverse_of: :transport_order

  belongs_to :carrier, class_name: 'Carrier', foreign_key: 'carrier_id'
  belongs_to :client, class_name:  'Client', foreign_key: 'client_id'
  belongs_to :seller, class_name: 'Client', foreign_key: 'seller_id'

  monetize :freight_rate_cents, numericality: {
    greater_than_or_equal_to: 0
  }

  monetize :profit_margin_cents, numericality: {
    greater_than_or_equal_to: 0
  }

  accepts_nested_attributes_for :transport_order_name, allow_destroy: true
  accepts_nested_attributes_for :freichtage_description
  accepts_nested_attributes_for :loading_places
  accepts_nested_attributes_for :unloading_places

  # validates :transport_order_name, presence: true
  validates :carrier, presence: true
  validates :client, presence: true
  validates :route, presence: true
  validates :loading_places, length: { minimum: 1 }
  validates :unloading_places, length: { minimum: 1 }

  scope :from_date, ->(year, month) {
    # TODO postgres/sqlite
    where("extract(year from created_at) = ? and extract(month from created_at) = ?", year, month)
    #where("strftime('%Y/%m', created_at) = ?", "#{year}/#{month.to_i > 9 ? month : '0' + month}")
  }

  before_save do
    self.client_name = client.name
    self.client_nip = client.nip
    self.client_street = client.address.street
    self.client_zip = client.address.zip
    self.client_city = client.address.city
    self.client_country = client.address.country
    self.client_phone = client.contact.phone1

    self.carrier_name = carrier.client.name
    self.carrier_nip = carrier.client.nip
    self.carrier_driver_name = carrier.driver_name
    self.carrier_street = carrier.client.address.street
    self.carrier_zip = carrier.client.address.zip
    self.carrier_city = carrier.client.address.city
    self.carrier_country = carrier.client.address.country
    self.car_registration_number = carrier.registration_number
    true
  end

  before_save :update_loading_date, if: :loading_status_changed?
  before_save :update_unloading_date, if: :unloading_status_changed?
  before_save :add_email_to_client

  def loading_status_human
    if loading_status == true
      return 'Wysłano'
    else
      return 'Nie wysłano'
    end
  end

  def unloading_status_human
    if unloading_status == true
      return 'Wysłano'
    else
      return 'Nie wysłano'
    end
  end

  def can_create_name
    errors = Array.new

    if transport_order_name.present?
      errors << "Zlecenie ma już numer"
    end

    if !loading_status
      errors << "Zlecenie nie zostało załadowane"
    end

    if !unloading_status
      errors << "Zlecenie nie zostało rozładowane"
    end

    if !cmr_number.present?
      errors << "Brak numeru CMR"
    end

    if !route.present?
      errors << "Pusta trasa"
    end

    return errors
  end

  def self.search(search_params)
    name_number = search_params[:transport_order_name_number]
    name_year = search_params[:transport_order_name_year]
    freichtage_rate = search_params[:freight_rate_cents]
    freichtage_rate = freichtage_rate.to_f * 100 if freichtage_rate.present?
    zip = search_params[:zip]
    zip = zip.downcase if zip
    city = search_params[:city]
    city = city.downcase if city
    client_name = search_params[:client_name]
    client_name = client_name.downcase if client_name
    client_id = search_params[:client_id]
    carrier_id = search_params[:carrier_id]
    carrier_name = search_params[:carrier_name]
    carrier_name = carrier_name.downcase if carrier_name
    driver_name = search_params[:driver_name]
    driver_name = driver_name.downcase if driver_name
    registration_number = search_params[:registration_number]
    registration_number = registration_number.downcase if registration_number
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

    if carrier_id.present?
      @transport_orders = @transport_orders.where('carriers.id = ?', carrier_id)
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

    @transport_orders.order('transport_order_names.year DESC, transport_order_names.number DESC')
  end

  private

  def update_loading_date
    loading_places.each do |loading_place|
      loading_place.date = DateTime.now
      loading_place.save
    end
  end

  def update_unloading_date
    unloading_places.each do |unloading_place|
      unloading_place.date = DateTime.now
      unloading_place.save
    end
  end

  def add_email_to_client
    if check_client_email == false
      email = Email.new()
      email.address = self.client_email
      self.client.contact.emails << email
      #client.save
    end
    true
  end

  # TODO zrefaktoryzować ta funkcje
  def check_client_email
    client_has_this_email = false
    self.client.emails.each do |email|
      if email.address.present? && email.address == self.client_email
        client_has_this_email = true
      end
    end
    return client_has_this_email
  end

end
