class InvoiceName < ActiveRecord::Base
    validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
    validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :number, uniqueness: { scope: [:month, :year] }
    def get_name
      return "#{number}/#{month}/#{year}"
    end

    def self.get_last_number_for_month(month)
      last_invoice_name = InvoiceName.where(month: month).order("number DESC").limit(1).first
      if last_invoice_name
        last_invoice_name.number + 1
      else
        1
      end
    end
end
