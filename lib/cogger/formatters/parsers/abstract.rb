# frozen_string_literal: true

module Cogger
  module Formatters
    module Parsers
      # An abstract class with common functionality.
      class Abstract
        TRANSFORMERS = {color: Transformers::Color.new, emoji: Transformers::Emoji.new}.freeze

        def initialize registry: Cogger, transformers: TRANSFORMERS, expressor: Regexp
          @registry = registry
          @transformers = transformers
          @expressor = expressor
        end

        def call(_template, **)
          fail NoMethodError,
               "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
        end

        protected

        attr_reader :registry, :transformers, :expressor

        def transform_color(...) = (@tranform_color ||= transformers.fetch(:color)).call(...)

        def transform_emoji(...) = (@transform_emoji ||= transformers.fetch(:emoji)).call(...)
      end
    end
  end
end
