class InvoicePriceValidator < ActiveModel::Validator
  def validate(record)
    invoice_net_price = record.net_price
    invocie_value_added_tax = record.value_added_tax
    invoice_total_selling_price = record.total_selling_price

    net_price_sum = 0.0
    value_added_tax_sum = 0.0
    total_selling_price_sum = 0.0

    record.invoice_items.each do |invoice_item|
      net_price_sum += invoice_item.net_price
      value_added_tax_sum += invoice_item.value_added_tax
      total_selling_price_sum += invoice_item.total_selling_price
    end

    if net_price_sum != invoice_net_price
      record.errors[:net_price] << "Invoice Net price is not valid is #{invoice_net_price} should be #{net_price_sum}"
    end

    if value_added_tax_sum != invocie_value_added_tax
      record.errors[:value_added_tax] << "Invoice Value added tax is #{invocie_value_added_tax} should be #{value_added_tax_sum}."
    end

    if total_selling_price_sum != invoice_total_selling_price
      record.errors[:total_selling_price] << "Invoice Total selling price is #{invoice_total_selling_price} should be #{total_selling_price_sum}"
    end
  end
end
