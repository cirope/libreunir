namespace :importer do
  desc 'Download the zip file, unzip it, and Formats and parse the csv files downloaded with the ftps class'
  task work: [:get_file, :unzip, :parse]
  
  task get_file: :environment do
    @ftps = Ftps.new
    @ftps.make_folder
    @ftps.set_mode
    @ftps.set_context
    @ftps.connect_and_login
    @ftps.get_file
  end

  task unzip: :environment do
    Unzipper.extract 
  end

  task parse: :environment do
    Formatter.create_directories
    Formatter.backup_zip_file
  end
end
