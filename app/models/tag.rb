class Tag < ActiveRecord::Base
  has_paper_trail
  
  CATEGORIES = ['default', 'success', 'warning', 'important', 'info', 'inverse']

  # Scopes
  default_scope { order("#{table_name}.name ASC") }
  scope :zones_by_loans, lambda { |loans| joins(:taggings).where(
      "#{table_name}.user_id IS NULL AND #{Tagging.table_name}.taggable_id IN(:loan_ids)", loan_ids: loans.map(&:id)
    ).uniq 
  }

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

  def set_category
    self.category ||= 'default'
  end

  def is_zone?
    !self.user_id
  end
end
