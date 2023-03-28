# frozen_string_literal: true

require "tone"

module Cogger
  # Provides default colors for all log levels.
  class Color
    DECORATOR = Tone.new.add debug: :white,
                             info: :green,
                             warn: :yellow,
                             error: :red,
                             fatal: %i[white bold on_red],
                             unknown: %i[white bold],
                             any: %i[white bold]

    def initialize decorator: DECORATOR
      @decorator = decorator
    end

    def debug(text) = decorator.call text, __method__

    def info(text) = decorator.call text, __method__

    def warn(text) = decorator.call text, __method__

    def error(text) = decorator.call text, __method__

    def fatal(text) = decorator.call text, __method__

    def unknown(text) = decorator.call text, __method__

    def any(text) = decorator.call text, __method__

    private

    attr_reader :decorator
  end
end
