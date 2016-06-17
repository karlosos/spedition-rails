json.extract! @item, :id, :unit, :created_at, :updated_at
json.unit_price humanized_money @item.unit_price
