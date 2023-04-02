# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # Dynamically extracts the universal or individual template attributes for log entry parsing.
      class Dynamic
        # Order matters.
        DELEGATES = [Universal.new, Individual.new].freeze

        def initialize delegates: DELEGATES
          @delegates = delegates
        end

        def call(template) = parse(template) || template

        private

        attr_reader :delegates

        def parse template
          delegates.find do |delegate|
            result = delegate.call template
            break result unless result == template
          end
        end
      end
    end
  end
end
