Fabricator(:call) do
  product_id { Faker::Lorem.sentence }
  note { Faker::Lorem.paragraph }
end
