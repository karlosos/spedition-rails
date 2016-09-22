class TransportOrderName < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member

  belongs_to :group
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :number, uniqueness: { scope: [:year, :group_id] }
  belongs_to :transport_order
  # validates :transport_order, presence: true

  def get_name
    "ZL #{number}/#{year}"
  end

  def self.get_last_number_for_year(year, group_id)
    last_transport_order_name = TransportOrderName.where('year = ? AND group_id = ?', year, group_id).order('number DESC').limit(1).first
    if last_transport_order_name
      last_transport_order_name.number + 1
    else
      1
    end
  end
end
