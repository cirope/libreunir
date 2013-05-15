set :environment, 'production'

every 5.minutes do
  runner 'Reminder.send_reminders'
end

every 1.day, at: '06:00 am' do
  rake 'parser:run'
end
