# frozen_string_literal: true

module Cogger
  module Formatters
    # Formats by emoji and color.
    class Emoji < Color
      TEMPLATE = "%<emoji:dynamic>s <dynamic>[%<id>s]</dynamic> %<message:dynamic>s"

      def initialize(template = TEMPLATE, ...)
        super
      end
    end
  end
end
