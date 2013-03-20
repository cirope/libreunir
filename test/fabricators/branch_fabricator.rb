Fabricator(:branch) do
  zone_id {  Fabricate(:zone).id }
  name { Faker::Name.name }
end
