class Schedule < ActiveRecord::Base
  include Schedules::DateCalculations
  include Schedules::DefaultDate
  include Schedules::Done
  include Schedules::Reminders
  include Schedules::Schedulable

  has_paper_trail

  # Scopes
  default_scope -> { order("scheduled_at ASC") }
  scope :pending, -> { where('done IS FALSE AND scheduled_at < ?', Time.now) }
  scope :for_tomorrow, -> {
    where(
      scheduled_at: (Date.tomorrow.at_beginning_of_day..Date.tomorrow.at_end_of_day)
    )
  }

  # Validations
  validates :user_id, :description, :scheduled_at, presence: true
  validates :scheduled_at, allow_nil: true, allow_blank: true,
    timeliness: { type: :datetime, on_or_after: :now }
  
  # Relations
  belongs_to :user
  has_many :notes, as: :noteable, dependent: :destroy
  has_many :reminders, dependent: :destroy
end
