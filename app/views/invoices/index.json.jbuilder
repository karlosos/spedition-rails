json.array!(@invoices) do |invoice|
  json.extract! invoice, :id
  json.name invoice.get_name
  json.url invoice_url(invoice, format: :json)
end
