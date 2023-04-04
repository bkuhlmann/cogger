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
        def call(*entry)
          severity, at, id, message = entry

          attributes = if message.is_a? Hash
                         {id:, severity:, at:, **message.except(:id, :severity, :at)}
                       else
                         {id:, severity:, at:, message:}
                       end

          filter attributes
        end

        private

        attr_reader :filters

        # :reek:FeatureEnvy
        def filter attributes
          filters.each { |key| attributes[key] = "[FILTERED]" if attributes.key? key }
          attributes
        end
      end
    end
  end
end
