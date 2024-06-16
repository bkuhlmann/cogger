# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats fatal crashes.
    class Crash
      TEMPLATE = <<~CONTENT
        <dynamic>[%<id>s] [%<level>s] [%<at>s] Crash!
          %<message>s
          %<error_message>s (%<error_class>s)
        %<backtrace>s</dynamic>
      CONTENT

      def initialize template = TEMPLATE, processor: Processors::Color.new
        @template = template
        @processor = processor
      end

      def call(*input)
        updated_template, attributes = processor.call(template, *input)
        attributes[:backtrace] = %(  #{attributes[:backtrace].join "\n  "})
        "#{format(updated_template, **attributes)}\n"
      end

      private

      attr_reader :template, :processor
    end
  end
end
