class Loan < ActiveRecord::Base
  include Loans::Client
  include Loans::Scopes

  has_paper_trail

  FILTERS = {
    expired: { formatter: :none },
    close_to_expire: { formatter: :none },
    loans_count: { formatter: :none },
    total_debt: { formatter: :currency }
  }

  # Validations
  validates :loan_id, presence: true
  validates :loan_id, uniqueness: true, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :branch
  belongs_to :user
  belongs_to :zone
  has_many :payments, dependent: :destroy
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

  def is_scheduled?
    self.schedules.present?
  end

  def find_tagging_by(tag)
    self.taggings.find_by(tag_id: tag.id)
  end
end
