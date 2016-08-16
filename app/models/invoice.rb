class Invoice < ActiveRecord::Base
  #default_scope { order('invoice_names.year DESC, invoice_names.month DESC, invoice_names.number DESC') }

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

  accepts_nested_attributes_for :invoice_name
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  validates :kind, presence: true
  validates :client, presence: true
  validates :seller, presence: true
  validates :invoice_name, presence: true
  validates :date, presence: true
  validates :place, presence: true
  validates :client_name, presence: true
  validates :client_street, presence: true
  validates :client_zip, presence: true
  validates :client_city, presence: true
  validates :client_country, presence: true
  validates :invoice_items, :length => { :minimum => 1 }
  validates :total_price_in_words, presence: true
  # validates :currency_rate_table_name, presence: true
  # validates :currency_rate, presence: true
  validates :currency_rate_name, presence: true
  validates :deadline, presence: true

  validates_with InvoicePriceValidator

  before_save do
    self.date_deadline = self.date + (self.deadline).days
    true
  end

  ISSUED    = 1
  SENT      = 2
  COMPLETED = 3


  STATUSES = {
    ISSUED    => 'wystawiona',
    SENT    => 'wysłana',
    COMPLETED => 'zapłacona'
  }

  KINDS = ['vat', 'proforma', 'correction']

  validates_inclusion_of :status, :in => STATUSES.keys,
    :message => "{{value}} must be in #{STATUSES.values.join ','}"

  validates_inclusion_of :kind, :in => KINDS, :message => "{{value}} must be in #{KINDS.join ','}"

  def status_name
    STATUSES[status]
  end

  def get_name
    return "#{invoice_name.number}/#{invoice_name.month}/#{invoice_name.year}"
  end

  def get_file_name
    return "#{invoice_name.number}-#{invoice_name.month}-#{invoice_name.year}"
  end

  def overdue
    date_deadline = date + (deadline).days
    return (Time.now - date_deadline)/(60*60*24)*-1
  end

  def proper_exchange_currency
    if !invoice_exchange_currency.present? || invoice_exchange_currency == "Nie przeliczaj"
      return currency_rate_name
    else
      return invoice_exchange_currency
    end
  end

  def self.search(search_params)
    kind = search_params[:kind]
    date = search_params[:date]
    client_name = search_params[:client_name]
    client_id = search_params[:client_id]
    item_id = search_params[:item_id]
    if client_name
      client_name = client_name.downcase
    end
    date_start = search_params[:date_start]
    date_stop = search_params[:date_stop]
    invoice_name_number = search_params[:invoice_name_number]
    invoice_name_month = search_params[:invoice_name_month]
    invoice_name_year = search_params[:invoice_name_year]
    statuses = search_params[:statuses]

    @invoices = Invoice.all

    if kind.present?
      @invoices = @invoices.where('lower(kind) LIKE ?', "%#{kind.downcase}%")
    end

    if client_id.present?
      @invoices = @invoices.where('clients.id = ?', client_id)
    end
    if invoice_name_number.present?
      @invoices = @invoices.where('invoice_names.number = ?', invoice_name_number)
    end

    if invoice_name_month.present?
      @invoices = @invoices.where('invoice_names.month = ?', invoice_name_month)
    end

    if invoice_name_year.present?
      @invoices = @invoices.where('invoice_names.year = ?', invoice_name_year)
    end

    if date_stop.present? && date_start.present?
      @invoices = @invoices.where('date >= ? AND date <= ? ', date_start.to_datetime, date_stop.to_datetime)
    elsif date_start.present?
      @invoices = @invoices.where('date >= ?', date_start.to_datetime)
    elsif date_stop.present?
      @invoices = @invoices.where('date <= ?', date_stop.to_datetime)
    end

    if date.present?
      @invoices = @invoices.where('date = ?', date.to_datetime)
    end

    if statuses
      @invoices = @invoices.where('status IN (?)', statuses)
    end

    if client_name.present?
      @invoices = @invoices.where('lower(client_name) LIKE ?', "%#{client_name}%")
    end

    if item_id.present?
      @invoices = @invoices.where('invoice_items.item_id = ?', item_id)
    end
    return @invoices.order('invoice_names.year DESC, invoice_names.month DESC, invoice_names.number DESC')
  end
end
