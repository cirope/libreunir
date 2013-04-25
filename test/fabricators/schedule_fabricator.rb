Fabricator(:schedule) do
  description { Faker::Lorem.paragraph }
  scheduled_at { rand(1.year).ago }
  schedulable_id { Fabricate(:loan).id }
  schedulable_type 'Loan'
end
