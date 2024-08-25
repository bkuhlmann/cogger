# frozen_string_literal: true

module Cogger
  module Formatters
    module Transformers
      # Transforms target into colorized string.
      class Color
        def initialize emoji: Emoji::KEY, key_transformer: Key, registry: Cogger
          @emoji = emoji
          @key_transformer = key_transformer
          @registry = registry
        end

        def call target, directive, level
          return target if !target.is_a?(String) || target == emoji

          key = key_transformer.call directive, level

          return client.encode target, key if aliases.key?(key) || defaults.key?(key)

          target
        end

        private

        attr_reader :emoji, :key_transformer, :registry

        def aliases = registry.aliases

        def defaults = client.defaults

        def client = registry.color
      end
    end
  end
end
