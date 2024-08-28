# frozen_string_literal: true

module Cogger
  module Formatters
    module Sanitizers
      # Sanitizes value as fully quoted string for emojis, spaces, and control characters.
      class Escape
        PATTERN = /
          \A              # Search string start.
          .*              # Match zero or more characters.
          (               # Conditional start.
          (?!\p{Number})  # Look ahead and ignore unicode numbers.
          \p{Emoji}       # Match unicode emoji only.
          |               # Or.
          [[:space:]]     # Match spaces, tabs, and new lines.
          |               # Or.
          [[:cntrl:]]     # Match control characters.
          )               # Conditional end.
          .*              # Match zero or more characters.
          \z              # Search string end.
        /xu

        def initialize pattern: PATTERN
          @pattern = pattern
        end

        def call value
          return dump value unless value.is_a? Array

          value.reduce(+"") { |text, item| text << dump(item) << ", " }
               .then { |text| %([#{text.delete_suffix ", "}]).dump }
        end

        private

        attr_reader :pattern

        def dump(value) = value.to_s.gsub(pattern, &:dump)
      end
    end
  end
end
