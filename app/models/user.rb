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

  # Relations
  belongs_to :branch
  has_many :loans, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :made_payments, class_name: 'Payment'
  has_many :payments, through: :loans
  has_many :clients, through: :loans
end
