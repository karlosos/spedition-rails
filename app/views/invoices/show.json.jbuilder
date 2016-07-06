json.extract! @invoice, :id, :created_at, :updated_at
json.status @invoice.status_name
