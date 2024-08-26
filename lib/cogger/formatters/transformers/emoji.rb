# frozen_string_literal: true

module Cogger
  module Formatters
    module Transformers
      # Transforms target into emoji.
      class Emoji
        KEY = "emoji"

        def initialize key = KEY, key_transformer: Key, registry: Cogger
          @key = key
          @key_transformer = key_transformer
          @registry = registry
        end

        def call target, directive, level
          return target unless target == key

          key = key_transformer.call directive, level

          registry.aliases.key?(key) ? registry.get_emoji(key) : target
        end

        private

        attr_reader :key, :key_transformer, :registry
      end
    end
  end
end
