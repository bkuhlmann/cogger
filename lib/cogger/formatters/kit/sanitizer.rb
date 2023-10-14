# frozen_string_literal: true

module Cogger
  module Formatters
    module Kit
      # Transforms a positional log entry into a hash entry for template parsing and formatting.
      class Sanitizer
        def initialize filters: Cogger.filters
          @filters = filters
        end

        # :reek:FeatureEnvy
        def call(*data)
          *, entry = data
          payload = entry.payload

          filters.each { |key| payload[key] = "[FILTERED]" if payload.key? key }
          entry
        end

        private

        attr_reader :filters
      end
    end
  end
end
