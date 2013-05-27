module Parser
  class Tag
    def self.parse(name, taggable)
      unless name.gsub('(null)', '').empty?
        tag = ::Tag.find_by(name: name)

        if tag.try(:persisted?)
          unless taggable.taggings.find_by(tag_id: tag.id)
            taggable.taggings.joins(:tag).where("#{::Tag.table_name}.user_id IS NULL").readonly(false).map(&:destroy)

            taggable.taggings.create(tag_id: tag.id)
          end
        else
          taggable.tags.create(name: name, category: 'info')
        end
      end
    end
  end
end
