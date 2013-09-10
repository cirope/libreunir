require 'csv'

namespace :exporter do
  task export: :environment do
    write_schedules_csv
    write_notes_csv

    make_zip
  end

  private

  # Schedules

  def write_schedules_csv
    CSV.open schedules_file, 'w' do |csv|
      csv << schedule_columns

      schedules.find_each { |schedule| csv << schedule_row(schedule) }
    end
  end

  def schedules_file
    'eventos.csv'
  end

  def schedule_columns
    ['ID', 'Descripción', 'Realizar el', 'Realizado', 'ID Préstamo']
  end

  def schedules
    Schedule.where.not(schedulable_id: nil)
  end

  def schedule_row schedule
    [
      schedule.id,
      schedule.description,
      schedule.scheduled_at.to_s(:db),
      schedule.done ? 'Si' : 'No',
      schedule.schedulable.loan_id
    ]
  end

  # Notes

  def write_notes_csv
    CSV.open notes_file, 'w' do |csv|
      csv << note_columns

      notes.find_each { |note| csv << note_row(note) }
    end
  end

  def notes_file
    'notas.csv'
  end

  def note_columns
    ['ID', 'Nota', 'Evento ID']
  end

  def notes
    Note.joins(
      "JOIN schedules ON noteable_type = 'Schedule' AND noteable_id = schedules.id"
    ).references(:schedules).where('schedules.schedulable_id IS NOT NULL')
  end

  def note_row note
    [note.id, note.note, note.noteable_id]
  end

  # Zip
  
  def make_zip
    zip_file = APP_CONFIG['zip']['filename']
    zip_password = APP_CONFIG['zip']['password']
    files = [schedules_file, notes_file].join ' '

    %x{zip #{zip_file} #{files} -m -P #{zip_password}}
  end
end
