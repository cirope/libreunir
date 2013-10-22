class Comment < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.created_at ASC") } 
  scope :inverse_order, -> { order("#{table_name}.created_at DESC") }
    
  # Validations
  validates :comment, :loan_id, :user_id, presence: true
  validates :comment, uniqueness: { case_sensitive: false, scope: [:user_id, :loan_id, :created_at] },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :loan
  belongs_to :user

  def to_s
    self.comment
  end
end
