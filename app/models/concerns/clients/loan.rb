module Clients::Loan
  extend ActiveSupport::Concern

  included do
    delegate :last_comments, to: :loan, prefix: true, allow_nil: true
  end
end
