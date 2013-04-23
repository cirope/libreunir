class Loan < ActiveRecord::Base
  include Loans::Client
  include Loans::Payments
  include Loans::Scopes

  has_paper_trail

  # Validations
  validates :loan_id, presence: true
  validates :loan_id, uniqueness: true, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :branch
  belongs_to :user

  def to_s
    self.loan_id.to_s
  end
end
