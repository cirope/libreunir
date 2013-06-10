class Tag < ActiveRecord::Base
  include Tags::Scopes

  has_paper_trail
  
  CATEGORIES = ['default', 'success', 'warning', 'important', 'info', 'inverse']

  # Callbacks
  after_initialize :set_category

  # Validations
  validates :name, :category, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { case_sensitive: false, scope: :user_id }, 
    allow_nil: true, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :loans, through: :taggings, source: :taggable, source_type: 'Loan'

  def to_s
    self.name
  end

  def set_category
    self.category ||= 'default'
  end

  def loans_count(loans)
    self.loans.where(id: loans.map(&:id)).count
  end
  
  def expired(loans)
    self.loans.where(id: loans.map(&:id)).expired.count
  end

  def close_to_expire(loans)
    self.loans.where(id: loans.map(&:id)).not_expired.with_expiration.policy.count
  end

  def total_debt(loans)
    self.loans.where(id: loans.map(&:id)).map(&:total_debt).reduce(:+)
  end
end
