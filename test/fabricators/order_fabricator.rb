Fabricator(:order) do
  order_id { 100 * rand }
  adviser_id { Faker::Lorem.sentence }
  segment_id { Faker::Lorem.sentence }
  branch_id { 100 * rand }
  zone_id { Faker::Lorem.sentence }
  assigned_adviser_id { Faker::Lorem.sentence }
end
