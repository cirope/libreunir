class Tagging < ActiveRecord::Base
  has_paper_trail
  
  # Validations
  validates :tag_id, presence: true
  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type] }

  # Relations
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
