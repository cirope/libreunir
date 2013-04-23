class Formatter
  require 'fileutils'

  def initialize
    @current_date = Time.new.strftime('%Y-%m-%d')
    @formatter = Logger.new("#{Rails.root}/log/formatter-#{@current_date}.log")
    @processed = "private/data/processed"
  end

  def info(klass, row, attributes)
    message = String.new
    message << "#{klass} - Row: #{row}"
    message << "#{klass} - Record not saved : #{attributes}"

    @formatter.info(message)
  end

  def create_directories
    FileUtils.mkdir_p(File.expand_path("private/backup"))
    FileUtils.mkdir_p(File.expand_path(@processed))
    FileUtils.mkdir_p(File.expand_path(@processed) + '/' + @current_date)
  end

  def backup_zip_file
    filename = APP_CONFIG['zip']['filename']

    origin = File.expand_path("private") + '/' + filename
    target = File.expand_path("private/backup/") + '/' + "#{filename.gsub('.zip', '')}-#{@current_date}.zip"

    FileUtils.mv(origin, target) if File.exists?(origin)
  end

  def move_processed(path)
    FileUtils.mv(
      path,
      File.expand_path(@processed) + '/' + "#{@current_date}/#{File.basename(path).downcase}"
    )
  end
end
