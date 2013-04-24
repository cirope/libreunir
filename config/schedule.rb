set :environment, 'production'

every 1.day, at: '06:00 am' do
  rake 'parser:run'
end
