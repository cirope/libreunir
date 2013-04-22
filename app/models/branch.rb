class Branch < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :branch_id, presence: true
  validates :branch_id, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :products
  has_many :users
end
