# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template elements for specific and dynamic colors.
      class Element < Abstract
        PATTERN = %r(
                    <                # Tag open start.
                    (?<name>\w+)     # Tag open name.
                    >                # Tag open end.
                    (?<content>.+?)  # Content.
                    </               # Tag close start.
                    \w+              # Tag close.
                    >                # Tag close end.
                  )mx

        def initialize pattern: PATTERN
          super()
          @pattern = pattern
        end

        def call(template, **)
          template.gsub! pattern do
            captures = expressor.last_match.named_captures
            color = colorizer.call(captures["name"], **)
            registry.color[captures["content"], color]
          end

          template
        end

        private

        attr_reader :pattern
      end
    end
  end
end
