class Formatter
  # TODO: Refactor all in smaller functions by purpouse
  # TODO: Refactor config to use an options hash instead single parameters
  require 'smarter_csv'
  require 'fileutils'

  @@formatter ||= Logger.new("#{Rails.root}/log/formatter-#{Time.new.strftime('%Y-%m-%d')}.log")

  def self.info(message=nil)
    @@formatter.info(message) unless message.nil?
  end

  def self.create_directories
    FileUtils.mkdir_p(File.expand_path("private/backup"))
    FileUtils.mkdir_p(File.expand_path("private/data/processed"))
    FileUtils.mkdir_p(File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}")
  end

  def self.convert_to_utf8
    Dir.glob(File.expand_path("private/data") + '/' + "*.txt").each do |file|
      handler = open(file, "rb:UTF-16LE")

      reader = handler.readlines
      headers = fix_header(reader)

      contents = parse_to_utf8(headers, reader)
      write_utf8(file, contents)

      File.unlink(file)
    end
  end

  def self.backup_zip_file
    FileUtils.mv(
      File.expand_path("private") + '/' + APP_CONFIG['zip']['filename'],
      File.expand_path("private/backup/") + '/' + "#{APP_CONFIG['zip']['filename'][0..-5]}-#{Time.new.strftime('%Y-%m-%d')}.zip"
    )
  end

  def self.parse_utf8_files
    Dir.glob(File.expand_path("private/data") + '/' + "*.csv").each do |file|
      filename = File.basename(file, "_utf8.csv").downcase
      klass = APP_CONFIG['table_maps'][filename].singularize.classify.constantize
      mappings = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"]

      truncate_tables(filename, klass)

      index = 0
      csv = SmarterCSV.process(file,
                                { col_sep: "|",
                                key_mapping: mappings.symbolize_keys! }
                              ) do |row|
        index += 1
        row = row.first
        attributes = (row.slice *(klass.attribute_names.map(&:to_sym)))
        hash_strip_nulls(attributes)
        key = mappings[:key]
        mappings[:fake_fields].each { |field| attributes[field.to_sym] = index } if mappings[:fake_fields]
        mappings[:remove_prefix].each do |k,v|
          k.each do |field|
            attributes[field.to_sym].slice!(v) if attributes[field.to_sym] && attributes[field.to_sym].is_a?(String)
          end
        end if mappings[:remove_prefix]
        record = klass.new(attributes).save(validate: false) if attributes[key.to_sym].present?

        unless record
          Formatter.info("#{klass} - Row: #{row}")
          Formatter.info("#{klass} - Record not saved : #{attributes}")
        end

        if (association = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"][:many_to_one_association]).present?
          association.each do |k,v|
            association_klass = v.singularize.classify.safe_constantize || v.camelize.constantize
            association_key = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"][:many_to_one_association_key]
            k.each do |field|
              association_attributes = { :"#{association_key[v]}" => strip_nulls(row[key.to_sym]), :"#{v}" => strip_nulls(row[field.to_sym]) }
              record = association_klass.new(association_attributes).save(validate: false) if row[key.to_sym].present? && row[field.to_sym].present?
              unless record
                Formatter.info("#{klass} - Row: #{row}")
                Formatter.info("#{association_klass} - Record not saved: #{association_attributes}")
              end
            end
          end
        end
      end
      move_processed(file)
    end
  end

  private

  def self.move_processed(file)
    FileUtils.mv(
      file,
      File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}/#{File.basename(file).downcase}"
    )
  end

  def self.strip_nulls(value)
    (value = '') if (value.is_a?(String) && value.match('null'))
    value
  end

  def self.hash_strip_nulls(hash)
    hash.each do |k,v|
      (v = '') if (v.is_a?(String) && v.match('null'))
    end
  end

  def self.truncate_tables(filename, klass)
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{klass.table_name}")
    if (association = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"]['many_to_one_association']).present?
      association.each do |k,v|
        association_klass = v.singularize.classify.safe_constantize || v.camelize.constantize
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{association_klass.table_name}")
      end
    end
  end

  def self.fix_header(reader)
    headers = reader[2].encode("UTF-8").split("\s")
    headers = headers.join('|').to_s
  end

  def self.parse_to_utf8(headers, reader)
    contents = String.new
    contents << headers << "\r\n"
    reader[4..-1].each do |line|
      contents << line.encode("UTF-8")
    end

    contents
  end

  def self.write_utf8(file, contents)
    writer = File.new("#{file[0..-5]}_utf8.csv", "w")
    writer << contents
    writer.close
  end
end
