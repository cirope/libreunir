class Comment < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.created_at ASC") } 
    
  # Validations
  validates :comment, :client_id, :user_id, presence: true
  validates :comment, uniqueness: { scope: [:client_id, :user_id], case_sensitive: false },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :client
  belongs_to :user
end
