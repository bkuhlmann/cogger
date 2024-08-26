# frozen_string_literal: true

module Cogger
  module Formatters
    module Processors
      # Processes template with entry input using all template parsers.
      class Color
        def initialize parser: Parsers::Combined.new, sanitizer: Kit::Sanitizer
          @parser = parser
          @sanitizer = sanitizer
        end

        def call(template, *input)
          attributes = sanitizer.call(*input).tagged
          [parser.call(template, attributes.fetch(:level)), attributes]
        end

        private

        attr_reader :parser, :sanitizer
      end
    end
  end
end
