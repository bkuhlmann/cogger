# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template and reorders attributes based on template key positions.
      class Position
        PATTERN = /
          %             # Start.
          ?             # Flag, width, or precision.
          <             # Reference start.
          (?<name>\w+)  # Name.
          (?::[\w]+)?   # Optional delimiter and directive.
          >             # Reference end.
          ?             # Specifier.
        /x

        def initialize pattern: PATTERN
          @pattern = pattern
        end

        # :reek:FeatureEnvy
        def call template, attributes
          return attributes if !template || template.empty?
          return attributes unless template.match? pattern

          keys = scan template
          attributes.slice(*keys).merge!(attributes.except(*keys))
        end

        private

        attr_reader :pattern

        def scan(template) = template.scan(pattern).map { |match| match.first.to_sym }
      end
    end
  end
end
