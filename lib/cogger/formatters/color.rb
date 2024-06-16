# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats by color.
    class Color
      TEMPLATE = "[%<id:dynamic>s] %<message:dynamic>s"

      def initialize template = TEMPLATE, processor: Processors::Color.new
        @template = template
        @processor = processor
      end

      def call(*input)
        updated_template, attributes = processor.call(template, *input)
        "#{format(updated_template, **attributes).tap(&:strip!)}\n"
      end

      private

      attr_reader :template, :processor
    end
  end
end
