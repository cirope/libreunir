require 'fileutils'

class Formatter
  PROCESSED_PATH = 'private/data/processed'

  def initialize
    @current_date = Time.new.strftime('%Y-%m-%d')
    @logger = create_logger
  end

  def info(klass, row, attributes)
    message  = "#{klass} - Row: #{row}"
    message << "#{klass} - Record not saved : #{attributes}"

    @logger.info(message)
  end

  def create_directories
    FileUtils.mkdir_p(File.expand_path('private/backup'))
    FileUtils.mkdir_p(File.expand_path(PROCESSED_PATH))
    FileUtils.mkdir_p(File.expand_path(PROCESSED_PATH) + '/' + @current_date)
  end

  def backup_zip_file
    filename = APP_CONFIG['zip']['filename']

    origin = File.expand_path('private') + '/' + filename
    target = File.expand_path('private/backup/') + '/' + "#{filename.gsub('.zip', '')}-#{@current_date}.zip"

    FileUtils.mv(origin, target) if File.exists?(origin)
  end

  def move_processed(path)
    FileUtils.mv(
      path,
      "#{File.expand_path(PROCESSED_PATH)}/#{@current_date}/#{File.basename(path).downcase}"
    )
  end

  def cleanup(klass)
    klass.where('updated_at < :today', today: Time.now.midnight).find_each(&:destroy)
  end

  def create_logger
    log_path = "#{Rails.root}/log/parser.log"

    unless File.exists?(log_path)
      FileUtils.mkdir_p File.dirname(log_path)
      FileUtils.touch log_path
    end

    Logger.new(log_path)
  end
end
