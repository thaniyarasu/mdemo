json.array!(@invites) do |invite|
  json.extract! invite, :id, :name, :document
  json.url invite_url(invite, format: :json)
end
