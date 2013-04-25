namespace :importer do
  desc 'Download the zip file, unzip it, and Formats and parse the csv files downloaded with the ftps class'
  task work: [:get_file, :unzip, :backup]
  
  task get_file: :environment do
    @ftps = Parser::Ftps.new
    @ftps.make_folder
    @ftps.set_mode
    @ftps.set_context
    @ftps.connect_and_login
    @ftps.get_file
  end

  task unzip: :environment do
    Parser::Unzipper.extract 
  end

  task backup: :environment do
    @processor = Parser::Processor.new

    @processor.create_directories
    @processor.backup_zip_file
  end
end
