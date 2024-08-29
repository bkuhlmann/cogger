# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats simple templates that require minimal processing.
    class Simple < Abstract
      TEMPLATE = "[%<id>s] %<message>s"

      def initialize template = TEMPLATE
        super()
        @template = template
      end

      def call(*input)
        *, entry = input
        attributes = sanitize entry, :tagged

        format(template, attributes).tap(&:strip!) << NEW_LINE
      end

      private

      attr_reader :template, :processor
    end
  end
end
