Fabricator(:phone) do
  client_id { Fabricate(:client).id }
  phone { 100 * rand }
end
