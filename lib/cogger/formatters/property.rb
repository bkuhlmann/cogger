# frozen_string_literal: true

require "core"

module Cogger
  module Formatters
    # Formats as key=value output.
    class Property < Abstract
      TEMPLATE = nil

      def initialize template = TEMPLATE, parser: Parsers::Position.new
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
        parser.call(template, attributes).each.with_object(+"") do |(key, value), line|
          line << key.to_s << "=" << escape(value) << " "
        end
      end
    end
  end
end
