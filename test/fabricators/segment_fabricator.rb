Fabricator(:segment) do
  segment_id { 100 * rand }
  description { Faker::Lorem.sentence }
  status { 100 * rand }
end
