module Tags::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope { order("#{table_name}.name ASC") }
  end
end
