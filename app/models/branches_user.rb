class BranchesUser < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :user_id, :branch_id, presence: true

  # Realtions
  belongs_to :user
  belongs_to :branch
end
