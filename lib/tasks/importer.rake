namespace :importer do
  desc 'Download the zip file, unzip it, and Formats and parse the csv files downloaded with the ftps class'
  task work: [:get_file, :unzip, :create_directories]

  task get_file: :environment do
    @ftps = Parser::Ftps.new
    @ftps.make_folder
    @ftps.get_file
  end

  task unzip: :environment do
    Parser::Unzipper.extract
  end

  task create_directories: :environment do
    Parser::Processor.new.create_directories
  end
end
