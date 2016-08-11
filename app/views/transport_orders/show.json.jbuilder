json.extract! @transport_order, :id, :created_at, :updated_at
json.status @transport_order.loading_status_human
