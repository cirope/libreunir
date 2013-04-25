require_relative '../parser/processor'
require_relative '../parser/logger'
require_relative '../parser/base'

namespace :parser do
  desc 'Parse CSV files from SFTP'
  task run: ['importer:work', :process, :cleanup]

  files = {
    branch: 'sucursal.txt',
    user: 'usuario.txt',
    order: 'solicitud.txt',
    loan: 'prestamo.txt',
    product: 'producto.txt',
    client: 'clientes.txt',
    payment: 'cuota.txt'
  }

  @processor = Parser::Processor.new

  task process: :environment do
    files.each do |model,file|
      path = Dir.glob(
        File.expand_path('private/data') + '/' + files[model], File::FNM_CASEFOLD
      ).first

      Parser::Logger.log "[ Parsing #{file} .... ========================================= ]"

      "Parser::#{model.to_s.capitalize}".constantize.new(path).parse

      @processor.move_processed(path)
    end
  end

  task cleanup: :environment do
    files.each do |model,file|
      klass = model.to_s.capitalize.constantize rescue ::Loan

      Parser::Logger.log "Cleaning #{klass}..."
      @processor.cleanup(klass)
    end
  end
end
