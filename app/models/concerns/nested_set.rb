module NestedSet
  extend ActiveSupport::Concern

  included do
    after_create :update_path
  end

  module ClassMethods
    def roots
      where("array_length(#{table_name}.path, 1) = 1")
    end
  end

  def update_path
    update_attributes(path: path.to_a << id)
  end

  def depth
    path.length
  end

  def root?
    depth == 1
  end

  def children
    where(
      'array_length(path, 1) = :depth AND (path && ARRAY[:id])', depth: (depth.next), id: id
    )
  end

  def self_and_descendents
    Tag.where('path && ARRAY[?]', self.id)
  end
end
