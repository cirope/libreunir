module Users::Hierarchy
  extend ActiveSupport::Concern

  included do
    has_ancestry
  end

  def has_ancestor?(user)
    path_ids.include?(user.id)
  end
end
