# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Sanitizes and extracts the universal directive a template.
      class Universal
        # rubocop:todo Lint/MixedRegexpCaptureTypes
        PATTERN = %r(
                    (                  # Conditional start.
                    \A                 # Search start.
                    <                  # Tag start.
                    (?<directive>\w+)  # Directive.
                    >                  # Tag end.
                    |                  # Conditional pipe.
                    <                  # Tag start.
                    /                  # Tag close.
                    (?<directive>\w+)  # Directive.
                    >                  # Tag end.
                    \Z                 # Search end.
                    )                  # Conditional end.
                  )mx
        # rubocop:enable Lint/MixedRegexpCaptureTypes

        KEY = "directive"

        def initialize pattern: PATTERN, key: KEY
          @pattern = pattern
          @key = key
        end

        def call template
          return template unless template.match? pattern

          [template.gsub(pattern, ""), template.match(pattern)[key]]
        end

        private

        attr_reader :pattern, :key
      end
    end
  end
end
