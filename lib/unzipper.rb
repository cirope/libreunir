class Unzipper
  require 'archive/zip'

  def self.extract
    Archive::Zip.extract(
      File.expand_path("private/" + '/' + "#{APP_CONFIG['zip']['filename']}"),
      File.expand_path("private/data"),
      :password => APP_CONFIG['zip']['password']
    )
  end
end
