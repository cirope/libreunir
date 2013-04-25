Fabricator(:schedule) do
  description { Faker::Lorem.paragraph }
  scheduled_at { 1.day.from_now.to_s(:db) }
  schedulable_id { Fabricate(:loan).id }
  schedulable_type 'Loan'
end
