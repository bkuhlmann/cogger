# frozen_string_literal: true

require "core"

module Cogger
  module Formatters
    module Parsers
      # Parses template for specific and dynamic keys (i.e. string format specifiers).
      class Key < Abstract
        PATTERN = /
          %                                   # Start.
          (?<flag>[\s#+-0*])?                 # Optional flag.
          \.?                                 # Optional precision.
          (?<width>\d+)?                      # Optional width.
          <                                   # Reference start.
          (?<key>\w+)                         # Key.
          :                                   # Delimiter.
          (?<directive>\w+)                   # Directive.
          >                                   # Reference end.
          (?<specifier>[ABEGXabcdefgiopsux])  # Specifier.
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
          template.gsub! pattern do |match|
            captures = expressor.last_match.named_captures
            directive = captures["directive"]
            match.sub! ":#{directive}", Core::EMPTY_STRING

            transform_color match, directive, level
          end
        end
      end
    end
  end
end
