# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Sanitizes and extracts individual directives from a template.
      class Individual
        # rubocop:todo Lint/MixedRegexpCaptureTypes
        PATTERN = /
                    %                                   # Strict reference syntax.
                    (?<flag>[\s#+-0*])?                 # Optional flag.
                    (?<width>\d+)?                      # Optional width.
                    \.?                                 # Optional precision delimiter.
                    (?<precision>\d+)?                  # Optional precision value.
                    <                                   # Reference start.
                    (                                   # Conditional start.
                    (?<key>\w+)                         # Key.
                    :                                   # Directive delimiter.
                    (?<directive>\w+)                   # Value.
                    |                                   # Conditional.
                    (?<key>\w+)                         # Key.
                    )                                   # Conditional end.
                    >                                   # Reference end.
                    (?<specifier>[ABEGXabcdefgiopsux])  # Specifier.
                  /mx
        # rubocop:enable Lint/MixedRegexpCaptureTypes

        def initialize pattern: PATTERN
          @pattern = pattern
        end

        def call template
          attributes = {}

          return [template, attributes] unless template.match? pattern

          template = sanitize_and_extract template, attributes
          [template, attributes]
        end

        private

        attr_reader :pattern

        # :reek:FeatureEnvy
        # :reek:TooManyStatements
        def sanitize_and_extract template, attributes
          template.gsub pattern do
            captures = Regexp.last_match.named_captures symbolize_names: true
            attributes[captures[:key].to_sym] = captures[:directive]

            captures.reduce(+"%") do |body, (key, value)|
              next body if key == :directive

              body.concat key == :key ? "<#{value}>" : value.to_s
            end
          end
        end
      end
    end
  end
end
