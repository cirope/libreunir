class Schedule < ActiveRecord::Base
  include Schedules::DateCalculations
  include Schedules::DefaultDate
  include Schedules::Done
  include Schedules::Reminders
  include Schedules::Schedulable

  has_paper_trail

  # Scopes
  default_scope -> { order("scheduled_at ASC") }

  # Validations
  validates :user_id, :description, :scheduled_at, presence: true
  validates :scheduled_at, allow_nil: true, allow_blank: true,
    timeliness: { type: :datetime, on_or_after: :now }
  
  # Relations
  belongs_to :user
  belongs_to :tenant, class_name: 'User'
  has_many :notes, as: :noteable, dependent: :destroy
  has_many :reminders, dependent: :destroy

  def move(date)
    self.update_attribute(
      :scheduled_at, self.scheduled_at.change(
        year: date.year, month: date.month, day: date.day
      )
    )
  end
end
