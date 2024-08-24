# frozen_string_literal: true

require "core"

module Cogger
  module Formatters
    # Formats as key=value output.
    class Property < Abstract
      TEMPLATE = nil

      def initialize template = TEMPLATE, parser: Parsers::KeyExtractor.new
        super()
        @template = template
        @parser = parser
      end

      def call(*input)
        *, entry = input
        attributes = sanitize(entry, :tagged_attributes).tap(&:compact!)

        concat(attributes).chop! << "\n"
      end

      private

      attr_reader :template, :parser

      def concat attributes
        reorder(attributes).each.with_object(+"") do |(key, value), line|
          line << key.to_s << "=" << escape(value) << " "
        end
      end

      def reorder attributes
        positions = positions_for template

        return attributes if positions.empty?

        attributes.slice(*positions).merge!(attributes.except(*positions))
      end

      def positions_for(template) = template ? parser.call(template) : Core::EMPTY_ARRAY
    end
  end
end
