# frozen_string_literal: true

require "core"

module Cogger
  module Formatters
    module Parsers
      # Parses template for specific and dynamic string format specifiers.
      class Specific < Abstract
        PATTERN = /
                    %                                   # Start.
                    (?<flag>[\s#+-0*])?                 # Optional flag.
                    (?<width>\d+)?                      # Optional width.
                    \.?                                 # Optional precision delimiter.
                    (?<precision>\d+)?                  # Optional precision value.
                    <                                   # Reference start.
                    (?<name>\w+)                        # Name.
                    :                                   # Delimiter.
                    (?<color>\w+)                       # Color.
                    >                                   # Reference end.
                    (?<specifier>[ABEGXabcdefgiopsux])  # Specifier.
                  /x

        def initialize pattern: PATTERN
          super()
          @pattern = pattern
        end

        # :reek:TooManyStatements
        def call(template, **)
          template.gsub! pattern do |match|
            captures = expressor.last_match.named_captures
            original_color = captures["color"]
            color = colorizer.call(original_color, **)

            match.sub! ":#{original_color}", Core::EMPTY_STRING
            registry.color[match, color]
          end

          template
        end

        private

        attr_reader :pattern
      end
    end
  end
end
