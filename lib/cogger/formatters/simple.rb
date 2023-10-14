# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats simple templates that require no additional processing.
    class Simple
      TEMPLATE = "%<message>s"

      def initialize template = TEMPLATE, sanitizer: Kit::Sanitizer
        @template = template
        @sanitizer = sanitizer
      end

      def call(*input) = "#{format(template, sanitizer.call(*input).tagged).tap(&:strip!)}\n"

      private

      attr_reader :template, :sanitizer
    end
  end
end
