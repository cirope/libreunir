module NestedSet
  extend ActiveSupport::Concern

  included do
    after_create :update_self
    after_update :update_self_and_descendents
  end

  module ClassMethods
    def roots
      where("array_length(#{table_name}.path, 1) = 1")
    end
  end

  def parent_id
    self.path[-2]
  end

  def parent_id=(pid)
    self.path = [pid.to_i, self.id.to_i]
  end

  def depth
    self.path.length
  end

  def root?
    self.depth == 1
  end

  def children
    self.class.where(
      'array_length(path, 1) = :depth AND (path && ARRAY[:id])', depth: (self.depth.next), id: self.id
    )
  end

  def self_and_descendents
    self.class.where('path && ARRAY[?]', self.id)
  end

  def parent
    self.class.find_by(id: self.parent_id)
  end

  def can_show?(tenant)
    tenant.path.include?(self.id) if tenant
  end

  private
    def update_self
      update_path(self, self.parent.try(:path))
    end

    def update_self_and_descendents
      self.self_and_descendents.each { |o| update_path(o, o.parent.try(:path)) } if self.path_changed?
    end

    def update_path(o, path)
      o.update_column(:path, "{#{[path.to_a << o.id].compact.join(',')}}")
    end
end
