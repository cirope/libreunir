Fabricator(:reminder) do
  schedule_id { Fabricate(:schedule).id }
  remind_at { |attrs| Schedule.find(attrs[:schedule_id]).scheduled_at - 2.hours }
  kind { Reminder::KINDS.sample }
  notified false
  scheduled { |attrs| attrs[:notified] }
end
