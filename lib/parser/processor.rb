require 'fileutils'

module Parser
  class Processor
    PROCESSED_PATH = 'private/data/processed'

    def initialize
      @current_date = Time.new.strftime('%Y-%m-%d')
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

    def cleanup
      Loan.where('updated_at < :date AND canceled_at IS NULL', date: Time.now.midnight).find_each do |l|
        l.without_versioning do
          l.update(
            total_debt: nil,
            progress: nil,
            days_overdue_average: nil,
            expired_payments_count: nil,
            payments_to_expire_count: nil,
            delayed_at: nil,
            next_payment_expire_at: nil
          )
        end
      end
    end
  end
end
