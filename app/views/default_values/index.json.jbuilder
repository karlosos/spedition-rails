json.array!(@default_values) do |default_value|
  json.extract! default_value, :id
  json.url default_value_url(default_value, format: :json)
end
