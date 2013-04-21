Fabricator(:comment) do
  comment { Faker::Lorem.paragraph }
  client { references }
end
