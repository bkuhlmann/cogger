# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template elements for specific and dynamic colors.
      class Element < Abstract
        PATTERN = %r(
          <                  # Tag open start.
          (?<directive>\w+)  # Tag open name.
          >                  # Tag open end.
          (?<content>.+?)    # Content.
          </                 # Tag close start.
          \w+                # Tag close.
          >                  # Tag close end.
        )mx

        def initialize pattern: PATTERN
          super()
          @pattern = pattern
        end

        def call template, level
          mutate template, level
          template
        end

        private

        attr_reader :pattern

        def mutate template, level
          template.gsub! pattern do
            captures = expressor.last_match.named_captures
            transform_color captures["content"], captures["directive"], level
          end
        end
      end
    end
  end
end
