json.array!(@carrier_memberships) do |carrier_membership|
  json.extract! carrier_membership, :id
  json.url carrier_membership_url(carrier_membership, format: :json)
end
