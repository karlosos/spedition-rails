json.extract! @client, :id, :name, :created_at, :updated_at
json.client_street @client.address.street
json.client_zip @client.address.zip
json.client_city @client.address.city
json.client_country @client.address.country
json.client_email @client.contact.email
json.client_phone @client.contact.phone1
