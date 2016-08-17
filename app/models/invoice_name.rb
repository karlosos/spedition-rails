class InvoiceName < ActiveRecord::Base
    validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
    validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :number, uniqueness: { scope: [:month, :year, :prefix] }
    belongs_to :invoice

    def get_name
      if self.invoice.kind == 'correction'
        return "#{prefix}#{number}/#{year}"
      else
        return "#{prefix}#{number}/#{month}/#{year}"
      end
    end

    def self.get_prefix_for_kind(kind)
      if kind == 'vat'
        return ''
      elsif kind == 'proforma'
        return 'P'
      elsif kind == 'correction'
        return 'K'
      end
    end

    def self.get_last_number_for_date(date, kind = 'vat')
      date = DateTime.parse(date)
      month = date.month
      year = date.year

      if kind == 'vat' || kind == 'proforma'
        last_invoice_name = InvoiceName.joins(:invoice).where('month = ? AND year = ? AND invoices.kind = ?' , month, year, kind).order("number DESC").limit(1).first
      elsif kind == 'correction'
        last_invoice_name = InvoiceName.joins(:invoice).where('year = ? AND invoices.kind = ?', year, kind).order("number DESC").limit(1).first
      end

      if last_invoice_name
        return last_invoice_name.number + 1
      else
        return 1
      end
    end
end
