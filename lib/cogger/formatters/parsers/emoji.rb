# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template emojis for specific and dynamic colors.
      class Emoji < Abstract
        PATTERN = /
          %<                 # Start.
          (?<key>emoji)      # Key.
          :                  # Delimiter.
          (?<directive>\w+)  # Directive.
          >s                 # End.
        /x

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
            transform_emoji captures["key"], captures["directive"], level
          end
        end
      end
    end
  end
end
