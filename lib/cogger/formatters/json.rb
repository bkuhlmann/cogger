# frozen_string_literal: true

require "json"

module Cogger
  module Formatters
    # Formats as JSON output.
    class JSON
      TEMPLATE = "%<id>s %<severity>s %<at>s %<message>s"

      def initialize template = TEMPLATE,
                     parser: Parsers::Individual.new,
                     sanitizer: Kit::Sanitizer
        @template = template
        @parser = parser
        @sanitizer = sanitizer
      end

      def call(*input)
        positions = parser.call(template).last.keys
        attributes = sanitizer.call(*input).tagged_attributes.tap(&:compact!)
        "#{attributes.slice(*positions).merge!(attributes.except(*positions)).to_json}\n"
      end

      private

      attr_reader :template, :parser, :sanitizer
    end
  end
end
