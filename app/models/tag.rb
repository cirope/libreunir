class Tag < ActiveRecord::Base
  has_paper_trail
  
  CATEGORIES = ['default', 'success', 'warning', 'important', 'info', 'inverse']

  # Scopes

  # Validations
  validates :name, :category, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :loans, through: :taggings, source: :taggable, source_type: 'Loan'

  def self.for_user_or_global(user)
    t = self.arel_table

    where(t[:user_id].eq(nil).or(t[:user_id].eq(user.id)))
  end
end
