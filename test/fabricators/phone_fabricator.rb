Fabricator(:phone) do
  client_id { Fabricate(:client).id }
  number { 100 * rand }
end
