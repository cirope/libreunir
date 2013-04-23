class Formatter
  require 'fileutils'

  @@formatter ||= Logger.new("#{Rails.root}/log/formatter-#{Time.new.strftime('%Y-%m-%d')}.log")

  def self.info(klass, row, attributes)
    message = String.new
    message << "#{klass} - Row: #{row}"
    message << "#{klass} - Record not saved : #{attributes}"
    @@formatter.info(message)
  end

  def self.create_directories
    FileUtils.mkdir_p(File.expand_path("private/backup"))
    FileUtils.mkdir_p(File.expand_path("private/data/processed"))
    FileUtils.mkdir_p(File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}")
  end

  def self.backup_zip_file
    origin = File.expand_path("private") + '/' + APP_CONFIG['zip']['filename']
    target = File.expand_path("private/backup/") + '/' + "#{APP_CONFIG['zip']['filename'][0..-5]}-#{Time.new.strftime('%Y-%m-%d')}.zip"
    FileUtils.mv(
      origin,
      target
    ) if File.exists?(origin)
  end

  def self.parse_files
    
    move_processed(file)
  end

  private

  def self.move_processed(file)
    FileUtils.mv(
      file,
      File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}/#{File.basename(file).downcase}"
    )
  end
end
