Fabricator(:segment) do
  segment_id { Faker::Lorem.characters(5) }
  description { Faker::Lorem.sentence }
  short_description { Faker::Lorem.sentence }
end
