module Users
  module DeviseCustomization
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :async, :recoverable, :rememberable,
        :trackable, :validatable
    end
  end
end
