set :environment, 'production'
every 1.day, at: '9:00 am' do
  rake 'ftps:get_zip'
  rake 'unzipper:extract'
  rake 'formatter:parse'
end
