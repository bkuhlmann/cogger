# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Parses template literals, emojis, and keys for specific and dynamic colors.
      class Combined
        STEPS = [Element.new, Emoji.new, Specific.new].freeze

        def initialize steps: STEPS
          @steps = steps
        end

        def call(template, **attributes)
          steps.reduce(template.dup) { |modification, step| step.call modification, **attributes }
        end

        private

        attr_reader :steps
      end
    end
  end
end
