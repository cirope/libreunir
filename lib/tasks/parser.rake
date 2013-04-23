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

  files.each do |klass,file|
    path = Dir.glob(
      File.expand_path("private/data") + '/' + files[klass], File::FNM_CASEFOLD
    ).first

    puts "[ Parsing #{file} .... ========================================= ]"

    parser = "Parser::#{klass.to_s.capitalize}".constantize.new(path)
    parser.parse

    @formatter.move_processed(path)
  end
end
