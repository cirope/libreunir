class User < ActiveRecord::Base
  include Users::Branch
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::Hierarchy
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles
  include Users::Validation

  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.name ASC") }

  # Relations
  has_many :loans
  has_many :comments
  has_many :schedules, dependent: :destroy
  has_many :payments, through: :loans
  has_many :clients, -> { uniq }, through: :loans
  has_many :tags, dependent: :destroy
  has_many :zones, -> { uniq }, through: :loans
end
