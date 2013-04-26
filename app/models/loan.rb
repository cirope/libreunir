class Loan < ActiveRecord::Base
  include Loans::Client
  include Loans::Scopes

  has_paper_trail

  # Validations
  validates :loan_id, presence: true
  validates :loan_id, uniqueness: true, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :branch
  belongs_to :user
  has_many :payments, dependent: :destroy
  has_many :schedules, as: :schedulable, dependent: :destroy

  def to_s
    self.loan_id.to_s
  end

  def expired?
    self.expired_payments_count > 0
  end

  def is_scheduled?
    self.schedules.present?
  end
end
