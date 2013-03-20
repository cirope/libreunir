class Formatter
  # TODO: Refactor all in smaller functions by purpouse
  require 'smarter_csv'
  require 'fileutils'

  def self.create_directories
    Dir.mkdir(File.expand_path("private/backup")) if !Dir.exist?(File.expand_path("private/backup"))
    Dir.mkdir(File.expand_path("private/data/processed")) if !Dir.exist?(File.expand_path("private/data/processed"))

    if !Dir.exist?(File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}")
      Dir.mkdir(File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}")
    end
  end

  def self.convert_to_utf8
    Dir.glob(File.expand_path("private/data") + '/' + "*.txt").each do |file|
      handler = open(file, "rb:UTF-16LE")

      reader = handler.readlines
      headers = reader[2].encode("UTF-8").split("\s")
      headers = headers.join('|').to_s

      contents = String.new
      contents << headers << "\r\n"
      reader[4..-1].each do |line|
        contents << line.encode("UTF-8")
      end

      writer = File.new("#{file[0..-5]}_utf8.csv", "w")
      writer << contents
      writer.close

      File.unlink(file)
    end
  end

  def self.backup_zip_file
    FileUtils.mv(
      File.expand_path("private") + '/' + APP_CONFIG['zip']['filename'],
      File.expand_path("private/backup/") + '/' + "#{APP_CONFIG['zip']['filename'][0..-5]}-#{Time.new.strftime('%Y-%m-%d')}.zip"
    ) if File.exist?(File.expand_path("private") + '/' + APP_CONFIG['zip']['filename'])
  end

  def self.parse_utf8_files
    Dir.glob(File.expand_path("private/data") + '/' + "*.csv").each do |file|
      filename = File.basename(file, "_utf8.csv").downcase
      klass = APP_CONFIG['table_maps'][filename].singularize.classify.constantize
      mappings = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"]

      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{klass.table_name}")
      if (association = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"]['many_to_one_association']).present?
        association.each do |k,v|
          association_klass = v.singularize.classify.safe_constantize || v.camelize.constantize
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{association_klass.table_name}")
        end
      end

      csv = SmarterCSV.process(file,
                                { col_sep: "|",
                                key_mapping: mappings.symbolize_keys! }
                              ) do |row|
        row = row.first
        attributes = (row.slice *(klass.attribute_names.map(&:to_sym)))
        key = mappings[:key]
        klass.new(attributes).save! if attributes[key.to_sym].present?

        if (association = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"][:many_to_one_association]).present?
          association.each do |k,v|
            association_klass = v.singularize.classify.safe_constantize || v.camelize.constantize
            association_key = APP_CONFIG["field_maps_#{APP_CONFIG['table_maps'][filename]}"][:many_to_one_association_key]
            k.each do |field|
              association_attributes = { :"#{association_key[v]}" => strip_nulls(row[key.to_sym]), :"#{v}" => strip_nulls(row[field.to_sym]) }
              association_klass.new(association_attributes).save! if row[key.to_sym].present? && row[field.to_sym].present?
            end
          end
        end
      end

      FileUtils.mv(
        file,
        File.expand_path("private/data/processed/") + '/' + "#{Time.new.strftime('%Y-%m-%d')}/#{File.basename(file).downcase}"
      )
    end
  end

  private

  def self.strip_nulls(value)
    (value = '') if (value.is_a?(String) && value.match('null'))
    value
  end
end
