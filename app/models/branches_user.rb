class BranchesUser < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :user, :branch, presence: true

  # Realtions
  belongs_to :user
  belongs_to :branch
end
