# frozen_string_literal: true

require "tone"

module Cogger
  module Formatters
    module Processors
      # Processes emojis and colors.
      class Color
        def initialize parser: Parsers::Dynamic.new,
                       kit: {sanitizer: Kit::Sanitizer.new, colorizer: Kit::Colorizer},
                       registry: Cogger
          @parser = parser
          @kit = kit
          @registry = registry
        end

        def call(template, *entry)
          attributes = sanitizer.call(*entry)

          case parser.call template
            in [String => body, String => style] then universal body, style, **attributes
            in [String => body, Hash => styles] then individual body, attributes, styles
            else [template, {}]
          end
        end

        private

        attr_reader :parser, :kit, :registry

        def universal body, style, **attributes
          [registry.color[body, colorizer.call(style, attributes)], attributes]
        end

        def individual body, attributes, styles
          attributes = attributes.each.with_object({}) do |(key, value), collection|
            collection[key] = registry.color[value, colorizer.call(styles[key], attributes)]
          end

          emojify attributes, styles
          [body, attributes]
        end

        def emojify attributes, styles
          style = styles[:emoji]

          return unless style

          attributes[:emoji] = registry.get_emoji colorizer.call(style, attributes)
        end

        def sanitizer = kit.fetch :sanitizer

        def colorizer = kit.fetch :colorizer
      end
    end
  end
end
