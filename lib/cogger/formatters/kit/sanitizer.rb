# frozen_string_literal: true

module Cogger
  module Formatters
    module Kit
      # Ensures log entry is filtered of sensitive data.
      Sanitizer = lambda do |*input, filters: Cogger.filters|
        *, entry = input
        payload = entry.payload

        filters.each { |key| payload[key] = "[FILTERED]" if payload.key? key }
        entry
      end
    end
  end
end
