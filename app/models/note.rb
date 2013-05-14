class Note < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.created_at ASC") }

  # Validations
  validates :note, presence: true

  # Relations
  belongs_to :noteable, polymorphic: true
end
