module Users
  module DeviseCustomization
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :recoverable, :rememberable, :trackable,
        :validatable
    end
  end
end
