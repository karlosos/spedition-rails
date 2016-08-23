class InvoiceItemPriceValidator < ActiveModel::Validator
  def validate(record)
    unit_price = record.unit_price_cents / 100.to_f
    quantity = record.quantity
    tax_rate = record.tax_rate

    net_price = record.net_price_cents / 100.to_f
    value_added_tax = record.value_added_tax_cents / 100.to_f
    total_selling_price = record.total_selling_price_cents / 100.to_f

    calculated_net_price = unit_price * quantity
    calculated_net_price = calculated_net_price.round(2)
    calculated_value_added_tax = calculated_net_price * (tax_rate / 100.to_f)
    calculated_value_added_tax = calculated_value_added_tax.round(2)
    calculated_total_selling_price = calculated_net_price + calculated_value_added_tax
    calculated_total_selling_price = calculated_total_selling_price.round(2)

    if calculated_net_price != net_price
      record.errors[:net_price] << "Net price is not valid is #{net_price} should be #{calculated_net_price}"
    end

    if calculated_value_added_tax != value_added_tax
      record.errors[:value_added_tax] << "Value added tax is #{value_added_tax} should be #{calculated_value_added_tax}."
    end

    if calculated_total_selling_price != total_selling_price
      record.errors[:total_selling_price] << "Total selling price is #{total_selling_price} should be #{calculated_total_selling_price}"
    end
    end
end
