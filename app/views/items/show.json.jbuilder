json.extract! @item, :id, :name, :unit, :created_at, :updated_at
json.unit_price humanized_money @item.unit_price
