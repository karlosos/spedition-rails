class InvoiceItemPriceValidator < ActiveModel::Validator
  def validate(record)
      unit_price = record.unit_price
      quantity = record.quantity
      tax_rate = record.tax_rate

      net_price = record.net_price
      value_added_tax = record.value_added_tax
      total_selling_price = record.total_selling_price

      calculated_net_price = unit_price * quantity
      calculated_value_added_tax = calculated_net_price * (tax_rate/100.to_f)
      calculated_total_selling_price = calculated_net_price + calculated_value_added_tax

      if calculated_net_price != net_price
        record.errors[:net_price] << "Net price is not valid is #{net_price} should be #{calculated_net_price}"
      end

      if calculated_value_added_tax != value_added_tax
        record.errors[:value_added_tax] << "Value added tax is #{value_added_tax} should be #{calculated_value_added_tax}."
      end

      if calculated_total_selling_price != total_selling_price
        record.errors[:total_selling_price] << "Total selling price is not #{total_selling_price} should be #{calculated_total_selling_price}"
      end
    end
end
