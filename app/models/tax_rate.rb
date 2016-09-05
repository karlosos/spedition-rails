class TaxRate < ActiveRecord::Base
  scope :important_only, -> { where('value IN (?)', [23, 5, 0, "zw", "nw"]) }
end
