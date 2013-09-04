class User < ActiveRecord::Base
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles
  include NestedSet

  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.name ASC") }

  # Validations
  validates :name, :username, presence: true
  validates :name, :email, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :username, uniqueness: { case_sensitive: false }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :branch
  has_many :loans
  has_many :comments
  has_many :schedules, dependent: :destroy
  has_many :payments, through: :loans
  has_many :clients, -> { uniq }, through: :loans
  has_many :tags, dependent: :destroy
  has_many :zones, -> { uniq }, through: :loans
end
