# frozen_string_literal: true

require "logger"
require "refinements/array"

# Loads log level from environment.
module Cogger
  using Refinements::Array

  Level = lambda do |logger = Logger, environment: ENV, allowed: LEVELS|
    value = String environment.fetch("LOG_LEVEL", "INFO")

    return logger.const_get value.upcase if allowed.include? value.downcase

    fail ArgumentError, %(Invalid log level: #{value.inspect}. Use: #{allowed.to_usage "or"}.)
  end
end
