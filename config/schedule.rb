set :environment, 'production'

every 1.day, at: '09:30 am' do
  rake 'importer:work'
end
