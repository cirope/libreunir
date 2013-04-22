class Comment < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.created_at ASC") } 
  scope :inverse_order, -> { order("#{table_name}.created_at DESC") }
    
  # Validations
  validates :comment, :client_id, :user_id, presence: true
  
  # Relations
  belongs_to :client
  belongs_to :user
end
