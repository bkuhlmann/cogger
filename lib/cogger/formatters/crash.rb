# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats fatal crashes.
    class Crash < Abstract
      TEMPLATE = <<~CONTENT
        <dynamic>[%<id>s] [%<level>s] [%<at>s] Crash!
          %<message>s
          %<error_message>s (%<error_class>s)
        %<backtrace>s</dynamic>
      CONTENT

      def initialize template = TEMPLATE, parser: Parsers::Combined.new
        super()
        @template = template
        @parser = parser
      end

      def call(*input)
        *, entry = input
        attributes = sanitize entry, :tagged
        attributes[:backtrace] = %(  #{attributes[:backtrace].join "\n  "})

        "#{format(parse(attributes[:level]), attributes)}\n"
      end

      private

      attr_reader :template, :parser

      def parse(level) = parser.call template, level
    end
  end
end
