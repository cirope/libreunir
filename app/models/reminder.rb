class Reminder < ActiveRecord::Base
  has_paper_trail

  KINDS = ['email']

  # Scopes
  default_scope -> { order("#{table_name}.remind_at ASC") }

  # Validations
  validates :remind_at, :kind, presence: true
  validates :kind, length: { maximum: 255 }, inclusion: { in: KINDS },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :schedule
end
