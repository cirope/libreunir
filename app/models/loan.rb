class Loan < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :loan_id, presence: true
  validates :loan_id, uniqueness: true, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :branch
  belongs_to :user
  belongs_to :client
end
