# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template and extracts keys.
      class KeyExtractor
        PATTERN = /
          %             # Start.
          ?             # Flag, width, or precision.
          <             # Reference start.
          (?<name>\w+)  # Name.
          (?::[\w]+)?   # Optional delimiter and or color.
          >             # Reference end.
          ?             # Specifier.
        /x

        def initialize pattern: PATTERN
          @pattern = pattern
        end

        def call(template) = template.scan(pattern).map { |match| match.first.to_sym }

        private

        attr_reader :pattern
      end
    end
  end
end
