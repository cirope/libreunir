class User < ActiveRecord::Base
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::Relations
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles

  has_paper_trail

  attr_accessor :welcome

  # Scopes
  default_scope -> { order("#{table_name}.lastname ASC") }
  scope :only_dependents, -> { where("relations.relation = ?", 'dependent') }

  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  has_many :orders, primary_key: 'adviser_id'
  has_many :fees, through: :orders
end
