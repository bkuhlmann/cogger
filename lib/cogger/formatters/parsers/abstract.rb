# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # An abstrct class with default functionality.
      class Abstract
        def initialize registry: Cogger, colorizer: Kit::Colorizer, expressor: Regexp
          @registry = registry
          @colorizer = colorizer
          @expressor = expressor
        end

        def call(_template, **)
          fail NoMethodError,
               "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
        end

        protected

        attr_reader :registry, :colorizer, :expressor
      end
    end
  end
end
