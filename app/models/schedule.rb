class Schedule < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.scheduled_at ASC") }

  # Validations
  validates :user_id, :description, :scheduled_at, presence: true
  validates :scheduled_at, allow_nil: true, allow_blank: true,
    timeliness: { type: :datetime, on_or_after: :now }
  
  # Relations
  belongs_to :user
  belongs_to :schedulable, polymorphic: true
end
