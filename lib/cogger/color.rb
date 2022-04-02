# frozen_string_literal: true

require "pastel"

module Cogger
  # Provides default colors for all log levels.
  class Color
    DEFAULTS = {
      debug: %i[white],
      info: %i[green],
      warn: %i[yellow],
      error: %i[red],
      fatal: %i[white bold on_red],
      any: %i[white bold]
    }.freeze

    def initialize defaults: DEFAULTS, decorator: Pastel.new(enabled: $stdout.tty?)
      @defaults = defaults
      @decorator = decorator
    end

    def debug(text) = decorate text, __method__

    def info(text) = decorate text, __method__

    def warn(text) = decorate text, __method__

    def error(text) = decorate text, __method__

    def fatal(text) = decorate text, __method__

    def any(text) = decorate text, __method__

    private

    attr_reader :defaults, :decorator

    def decorate(text, kind) = decorator.decorate text, *defaults.fetch(kind)
  end
end
