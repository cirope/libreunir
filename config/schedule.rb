set :environment, 'production'
every 1.day, at: '9:00 am' do
  rake 'fpts:get_zip'
  rake 'unzipper:extract'
  rake 'formatter:parse'
end
