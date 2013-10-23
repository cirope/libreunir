class Payment < ActiveRecord::Base
  include Payments::Calculations

  has_paper_trail

  # Scopes
  scope :pending, -> { where("#{table_name}.paid_at" => nil) }

  # Validations
  validates :number, :expired_at, :loan_id, presence: true
  
  # Relations
  belongs_to :loan
  belongs_to :user

  def interest
    total_paid - (capital + additional) rescue 0
  end
end
