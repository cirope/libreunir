class User < ActiveRecord::Base
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles

  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.username ASC") }

  # Validations
  validates :name, :username, presence: true
  validates :name, :email, length: { maximum: 255 }, 
    allow_nil: true, allow_blank: true
  validates :identification, :file_number, numericality: { only_integer: true },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :branch
  has_many :comments
  has_many :payments
  has_many :loans, through: :payments
end
