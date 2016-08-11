json.client_name @client.name
json.client_street @client.address.street
json.client_zip @client.address.zip
json.client_city @client.address.city
json.client_country @client.address.country
json.client_email @client.contact.email
json.client_phone @client.contact.phone1
json.client_info "#{@client.name}, NIP: #{@client.nip}, #{@client.address.street}, #{@client.address.city}"
json.extract! @client, :id
