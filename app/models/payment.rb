class Payment < ActiveRecord::Base
  include Payments::Calculations
  include Payments::Client
  include Payments::Scopes

  has_paper_trail

  # Validations
  validates :number, :expired_at, :loan_id, presence: true
  
  # Relations
  belongs_to :loan
  belongs_to :user
end
