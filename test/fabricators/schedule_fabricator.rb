Fabricator(:schedule) do
  description { Faker::Lorem.paragraph }
  scheduled_at { 1.day.from_now.to_s(:db) }
  done false
  user_id { Fabricate(:user).id }
  schedulable_id { Fabricate(:loan).id }
  schedulable_type 'Loan'
end
