set :environment, 'production'

every 5.minutes do
  rake 'reminders:send'
end

every 1.day, at: '06:00 am' do
  rake 'parser:run'
end

every 1.day, at: '07:00 am' do
  rake 'reminders:send_summaries'
end
