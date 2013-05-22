class Tagging < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type] }

  # Relations
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  accepts_nested_attributes_for :tag, reject_if: ->(attrs) { 
    ['name', 'category'].all? { |a| attrs[a].blank? } 
  }
end
