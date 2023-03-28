# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats by color.
    class Color
      TEMPLATE = "%<message:dynamic>s"

      def initialize template = TEMPLATE, processor: Processors::Color.new
        @template = template
        @processor = processor
      end

      def call(*entry)
        updated_template, attributes = processor.call(template, *entry)
        "#{format(updated_template, **attributes)}\n"
      end

      private

      attr_reader :template, :processor
    end
  end
end
