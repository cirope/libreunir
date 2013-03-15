Fabricator(:segment) do
  segment_id { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  status { 100 * rand }
end
