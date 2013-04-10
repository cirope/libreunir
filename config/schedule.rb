set :environment, 'production'
every 1.day, at: '9:00 am' do
  rake 'importer:work'
end
