 class Tag < ActiveRecord::Base
  include NestedSet
  include Filters

  has_paper_trail
  
  CATEGORIES = ['default', 'success', 'warning', 'important', 'info', 'inverse']

  # Scopes
  default_scope { order("#{table_name}.name ASC") }

  # Callbacks
  after_initialize :initialize_attrs

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

  def initialize_attrs
    self.category ||= 'default'
  end
end
