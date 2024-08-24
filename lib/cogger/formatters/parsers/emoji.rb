# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template emojis for specific and dynamic colors.
      class Emoji < Abstract
        PATTERN = /
          %<             # Start.
          emoji          # Name.
          :              # Delimiter.
          (?<color>\w+)  # Color.
          >s             # End.
        /x

        def initialize pattern: PATTERN
          super()
          @pattern = pattern
        end

        def call(template, **)
          template.gsub! pattern do
            captures = expressor.last_match.named_captures
            color = colorizer.call(captures["color"], **)

            registry.get_emoji color
          end

          template
        end

        private

        attr_reader :pattern
      end
    end
  end
end
