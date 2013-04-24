require_relative '../parser/base'

namespace :parser do

  desc 'Parse csv files from SFTP'
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

  task process: :environment do
    @formatter = Formatter.new

    files.each do |model,file|
      path = Dir.glob(
        File.expand_path("private/data") + '/' + files[model], File::FNM_CASEFOLD
      ).first

      puts "[ Parsing #{file} .... ========================================= ]"

      "Parser::#{model.to_s.capitalize}".constantize.new(path).parse

      @formatter.move_processed(path)
    end
  end

  task cleanup: :environment do
    files.each do |model,file|
      klass = model.to_s.capitalize.constantize rescue 'Loan'.constantize

      @formatter.table_cleanup(klass)
    end
  end
end
