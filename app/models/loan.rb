class Loan < ActiveRecord::Base
  include Loans::Client
  include Loans::Scopes
  include Loans::MagickColumns

  has_paper_trail

  # Validations
  validates :loan_id, presence: true
  validates :loan_id, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :branch
  belongs_to :user
  belongs_to :zone
  belongs_to :segment
  has_many :payments, dependent: :destroy, counter_cache: ''
  has_many :schedules, as: :schedulable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  def to_s
    self.loan_id.to_s
  end

  def label
    self.client
  end

  def expired?
    self.expired_payments_count > 0
  end

  def closest_schedule(user)
    self.schedules.where(user_id: user.id, done: false).first
  end
end
