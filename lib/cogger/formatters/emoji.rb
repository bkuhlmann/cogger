# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats by emoji and color.
    class Emoji < Color
      TEMPLATE = "%<emoji:dynamic>s [%<id:dynamic>s] %<message:dynamic>s"

      def initialize(template = TEMPLATE, ...)
        super
      end
    end
  end
end
