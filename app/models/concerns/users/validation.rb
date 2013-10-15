module Users::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :username, presence: true
    validates :name, :email, length: { maximum: 255 }, allow_nil: true, allow_blank: true
    validates :username, uniqueness: { case_sensitive: false }, allow_nil: true, allow_blank: true
  end
end
