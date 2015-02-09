json.array!(@emails) do |email|
  json.extract! email, :id, :subject, :message, :recipients
  json.url email_url(email, format: :json)
end
