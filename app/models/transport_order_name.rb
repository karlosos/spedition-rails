class TransportOrderName < ActiveRecord::Base
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :number, uniqueness: { scope: [:year] }
  belongs_to :transport_order

  def get_name
    return "ZL #{number}/#{year}"
  end

  def self.get_last_number_for_year(year)
    last_transport_order_name = InvoiceName.where('year = ?' , year).order("number DESC").limit(1).first
    if last_transport_order_name
      last_transport_order_name.number + 1
    else
      1
    end
  end
end
