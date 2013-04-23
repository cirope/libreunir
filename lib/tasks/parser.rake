require_relative '../parser/base'

task parser: 'importer:work' do

  @formatter = Formatter.new

  files = {
    branch: 'sucursal.txt',
    user: 'usuario.txt',
    order: 'solicitud.txt',
    loan: 'prestamo.txt',
    product: 'producto.txt',
    client: 'clientes.txt',
    payment: 'cuota.txt'
  }

  files.each do |model,file|
    path = Dir.glob(
      File.expand_path("private/data") + '/' + files[model], File::FNM_CASEFOLD
    ).first

    puts "[ Parsing #{file} .... ========================================= ]"

    klass = model.to_s.capitalize
    "Parser::#{klass}".constantize.new(path).parse

    @formatter.move_processed(path)
    @formatter.table_cleanup(klass)
  end
end
