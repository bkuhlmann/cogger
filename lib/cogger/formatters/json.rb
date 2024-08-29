# frozen_string_literal: true

require "core"
require "json"

module Cogger
  module Formatters
    # Formats as JSON output.
    class JSON < Abstract
      TEMPLATE = nil

      def initialize template = TEMPLATE, parser: Parsers::Position.new
        super()
        @template = template
        @parser = parser
      end

      def call(*input)
        *, entry = input
        attributes = sanitize(entry, :tagged_attributes).tap(&:compact!)

        parser.call(template, attributes).to_json << NEW_LINE
      end

      private

      attr_reader :template, :parser
    end
  end
end
