class Branch < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :branch_id, presence: true, uniqueness: true

  # Relations
  has_many :products
  has_many :users
end
