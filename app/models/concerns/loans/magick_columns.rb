module Loans::MagickColumns
  extend ActiveSupport::Concern

  included do
    has_magick_columns loan_id: :integer, 'clients.name' => :string, 'clients.lastname' => :string
  end

  module ClassMethods
    def filtered_list(query)
      query.present? ? magick_search(query) : all
    end
  end
end
