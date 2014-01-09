require 'fileutils'

module Parser
  class Processor
    PROCESSED_PATH = 'private/data/'

    def initialize
      @current_date = Time.new.strftime('%Y-%m-%d')
    end

    def create_directories
      FileUtils.mkdir_p(File.expand_path(PROCESSED_PATH))
      FileUtils.mkdir_p(File.expand_path(PROCESSED_PATH) + '/' + @current_date)
    end

    def cleanup_files
      filename = APP_CONFIG['zip']['filename']

      data_file = File.expand_path('private') + '/' + filename
      FileUtils.rm(data_file) if File.exists?(data_file)

      FileUtils.remove_dir(PROCESSED_PATH) if Dir.exists?(PROCESSED_PATH)
    end

    def cleanup
      not_renewed_to_history
      current_to_standby
      no_delayed_is_not_debtor
      not_renewed_has_all_payments_paid
      segments_to_standby
    end

    private
      def current_to_standby
        ::Loan.current.where('updated_at < :date', date: Time.now.midnight).find_each do |l|
          l.without_versioning { l.update(state: 'standby') }
        end
      end

      def not_renewed_to_history
        ::Loan.not_renewed.find_each do |l|
          l.without_versioning do
            if ::Loan.current.joins(:client).where(
              "#{::Client.table_name}.identification = ?", l.client.identification
            ).exists?
              l.update(state: 'history')
            end
          end
        end
      end

      def no_delayed_is_not_debtor
        ::Loan.debtor.where(delayed_at: nil).find_each do |l|
          l.without_versioning { l.update(debtor: false) }
        end
      end

      def not_renewed_has_all_payments_paid
        ::Loan.not_renewed.find_each do |l|
          l.payments.where(paid_at: nil).each do |p|
            p.without_versioning { p.update(paid_at: (l.canceled_at || Time.now)) }
          end
        end
      end

      def segments_to_standby
        segments = ['DCHT', 'PLCH']

        ::Loan.close_to_expire.where(
          progress: 100, segment_id: ::Segment.where(segment_id: segments).pluck('id')
        ).find_each { |l| l.without_versioning { l.update(state: 'standby') } }
      end
  end
end
