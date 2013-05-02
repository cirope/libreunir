module Users
  module Overrides
    extend ActiveSupport::Concern

    def to_s
      self.name
    end

    alias_method :label, :to_s


    def as_json(options = nil)
      default_options = {
        only: [:id],
        methods: [:label]
      }

      super(default_options.merge(options || {}))
    end
  end
end
