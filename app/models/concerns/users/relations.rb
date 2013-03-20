module Users
  module Relations
    extend ActiveSupport::Concern

    included do
      has_many :relations, dependent: :destroy
      has_many :inverse_relations, class_name: 'Relation', foreign_key: 'relative_id'
      has_many :relatives, through: :relations
      has_many :dependents, through: :inverse_relatives, source: :user

      accepts_nested_attributes_for :relations, allow_destroy: true,
      reject_if: ->(attributes) {
        attributes['relation'].blank? && attributes['user_id'].blank?
      }
    end
  end
end
