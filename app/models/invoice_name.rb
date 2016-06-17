class InvoiceName < ActiveRecord::Base
    validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
    validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }

    def get_name
      return "#{number}/#{month}/#{year}"
    end

    def self.get_last_number_for_month(month)
      return InvoiceName.where(month: month).order("number DESC").limit(1)
    end
end
