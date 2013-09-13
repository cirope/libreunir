class User < ActiveRecord::Base
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles

  has_paper_trail
  has_ancestry

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
  has_many :branches_users
  has_many :branches, through: :branches_users
  has_many :branches_loans, through: :branches, source: :loans
  has_many :branches_zones, through: :branches, source: :zones
  has_many :branches_tags, through: :branches, source: :tags

  def has_ancestor?(user)
    self.path_ids.include?(user.id)
  end
end
