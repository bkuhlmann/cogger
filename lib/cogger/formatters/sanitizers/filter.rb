# frozen_string_literal: true

module Cogger
  module Formatters
    module Sanitizers
      # Sanitizes/removes sensitive values.
      Filter = lambda do |attributes, filters: Cogger.filters|
        filters.each { |key| attributes[key] = "[FILTERED]" if attributes.key? key }
        attributes
      end
    end
  end
end
