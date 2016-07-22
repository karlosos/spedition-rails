json.array!(@clients) do |client|
  json.extract! client, :id
  json.client_info "#{client.name}, NIP: #{client.nip}, #{client.address.street}, #{client.address.city}"
  json.url client_url(client, format: :json)
end
