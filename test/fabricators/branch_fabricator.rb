Fabricator(:branch) do
  zone_id { references }
  name { Faker::Name.name }
end
