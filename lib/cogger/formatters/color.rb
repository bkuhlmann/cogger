# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats by color.
    class Color < Abstract
      TEMPLATE = "<dynamic>[%<id>s]</dynamic> %<message:dynamic>s"

      def initialize template = TEMPLATE, parser: Parsers::Combined.new
        super()
        @template = template
        @parser = parser
      end

      def call(*input)
        *, entry = input
        attributes = sanitize entry, :tagged

        format(parse(attributes[:level]), attributes).tap(&:strip!) << NEW_LINE
      end

      private

      attr_reader :template, :parser

      def parse(level) = parser.call template, level
    end
  end
end
