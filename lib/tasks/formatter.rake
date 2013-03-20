namespace :formatter do
  desc 'Formats and parse the csv files downloaded with the ftps class'
  task parse: :environment do
    Formatter.create_directories
    Formatter.convert_to_utf8
    Formatter.backup_zip_file
    Formatter.parse_utf8_files
  end
end
