# frozen_string_literal: true

require "core"
require "json"

module Cogger
  module Formatters
    # Formats as JSON output.
    class JSON
      TEMPLATE = nil

      def initialize template = TEMPLATE,
                     parser: Parsers::KeyExtractor.new,
                     sanitizer: Kit::Sanitizer
        @positions = template ? parser.call(template) : Core::EMPTY_ARRAY
        @sanitizer = sanitizer
      end

      def call(*input)
        attributes = sanitizer.call(*input).tagged_attributes.tap(&:compact!)
        format_date_time attributes

        return "#{attributes.to_json}\n" if positions.empty?

        "#{attributes.slice(*positions).merge!(attributes.except(*positions)).to_json}\n"
      end

      private

      attr_reader :positions, :sanitizer

      # :reek:UtilityFunction
      def format_date_time attributes
        attributes[:at] = attributes[:at].utc.strftime "%Y-%m-%dT%H:%M:%S.%L%:z"
      end
    end
  end
end
