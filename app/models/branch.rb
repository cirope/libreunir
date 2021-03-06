class Branch < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :branch_id, presence: true, uniqueness: true

  # Relations
  has_many :loans
  has_many :users, dependent: :destroy
  has_many :zones
  has_many :tags
end
