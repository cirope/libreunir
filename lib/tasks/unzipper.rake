namespace :unzipper do
  desc 'Unzip the file defined in config'
  task extract: :environment do
    Unzipper.extract
  end
end
