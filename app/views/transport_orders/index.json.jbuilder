json.array!(@transport_orders) do |transport_order|
  json.extract! transport_order, :id
  json.url transport_order_url(transport_order, format: :json)
end
