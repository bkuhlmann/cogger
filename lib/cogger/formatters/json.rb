# frozen_string_literal: true

require "core"
require "json"

module Cogger
  module Formatters
    # Formats as JSON output.
    class JSON < Abstract
      TEMPLATE = nil

      def initialize template = TEMPLATE, parser: Parsers::KeyExtractor.new
        super()
        @template = template
        @parser = parser
      end

      def call(*input)
        *, entry = input
        attributes = sanitize(entry, :tagged_attributes).tap(&:compact!)

        %(#{reorder(attributes).to_json}\n)
      end

      private

      attr_reader :template, :parser

      def reorder attributes
        positions = positions_for template

        return attributes if positions.empty?

        attributes.slice(*positions).merge!(attributes.except(*positions))
      end

      def positions_for(template) = template ? parser.call(template) : Core::EMPTY_ARRAY
    end
  end
end
