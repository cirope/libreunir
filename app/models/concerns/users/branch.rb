module Users::Branch
  extend ActiveSupport::Concern

  included do
    belongs_to :branch
    has_many :branches_users
    has_many :branches, through: :branches_users
    has_many :branches_loans, through: :branches, source: :loans
    has_many :branches_zones, through: :branches, source: :zones
    has_many :branches_tags, through: :branches, source: :tags
  end
end
