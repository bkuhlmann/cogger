# frozen_string_literal: true

require "core"
require "json"

module Cogger
  module Formatters
    # Formats as JSON output.
    class JSON
      TEMPLATE = nil

      def initialize template = TEMPLATE,
                     parser: Parsers::Individual.new,
                     sanitizer: Kit::Sanitizer
        @positions = template ? parser.call(template).last.keys : Core::EMPTY_ARRAY
        @sanitizer = sanitizer
      end

      def call(*input)
        attributes = sanitizer.call(*input).tagged_attributes.tap(&:compact!)

        return "#{attributes.to_json}\n" if positions.empty?

        "#{attributes.slice(*positions).merge!(attributes.except(*positions)).to_json}\n"
      end

      private

      attr_reader :positions, :sanitizer
    end
  end
end
