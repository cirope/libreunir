every 1.day, at: '6:00 am' do
  rake 'fpts:get_zip'
  rake 'unzipper:extract'
  rake 'formatter:parse'
end
