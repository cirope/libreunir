class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include Users::Comparable
  include Users::DeviseCustomization
  include Users::MagickColumns
  include Users::Overrides
  include Users::Roles

  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.username ASC") }

  # Validations
  validates :name, :username, :branch_id, presence: true
  validates :name, :email, length: { maximum: 255 }, 
    allow_nil: true, allow_blank: true
  validates :identification, :file_number, numericality: { only_integer: true },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :branch
  has_many :orders, primary_key: 'adviser_id'
  has_many :fees, through: :orders
end
