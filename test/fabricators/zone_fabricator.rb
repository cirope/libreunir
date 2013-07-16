Fabricator(:zone) do
  name { Faker::Name.name }
  zone_id { Faker::Lorem.characters(4) }
  branch_id { Fabricate(:branch).id }
end
