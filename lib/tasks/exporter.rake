namespace :exporter do
  desc 'Export schedules into a JSON file and then ZIP it and then ship it =)'
  task run: :environment do
    if APP_CONFIG['zip']['export_password']
      write_schedules_json

      make_zip
      upload_zip
      remove_zip
    end
  end

  private

  # Schedules

  def write_schedules_json
    File.open schedules_file, 'w' do |file|
      file << Jbuilder.encode { |json| schedules_to_json json }
    end
  end

  def schedules_file
    'eventos.json'
  end

  def schedules
    Schedule.includes(:notes, :schedulable).where('schedules.updated_at > ?', 3.days.ago).where.not(schedulable_id: nil)
  end

  def schedules_to_json json
    json.set! :Eventos do
      json.array! schedules do |schedule|
        json.id schedule.id
        json.usuario schedule.user.username
        json.descripcion schedule.description
        json.hacer_el schedule.scheduled_at.utc
        json.creado_el schedule.created_at.utc
        json.hecho schedule.done
        json.prestamo_id schedule.schedulable.loan_id

        json.notas schedule.notes.map { |n| { nota: n.note } }
      end
    end
  end

  # Zip
  
  def make_zip
    zip_password = APP_CONFIG['zip']['export_password']

    %x{zip #{zip_file} #{schedules_file} -m -P #{zip_password}}
  end

  def zip_file
    "#{Rails.root}/tmp/EVENTOS#{Date.today.strftime '%Y%m%d'}.zip"
  end

  def upload_zip
    ftps = Parser::Ftps.new

    ftps.put_file zip_file
  end

  def remove_zip
    %x{rm #{zip_file}}
  end
end
