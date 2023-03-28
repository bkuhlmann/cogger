# frozen_string_literal: true

require "forwardable"
require "logger"
require "refinements/loggers"
require "tone"

module Cogger
  # Provides the primary client for colorized logging.
  class Client
    extend Forwardable

    using Refinements::Loggers

    delegate %i[formatter level progname debug info warn error fatal unknown] => :logger

    def initialize logger = Logger.new($stdout), color: Cogger.color, **attributes
      @logger = logger
      @color = color
      @attributes = attributes

      configure
      yield logger if block_given?
    end

    def any(...) = logger.unknown(...)

    def reread = logger.reread

    private

    attr_reader :logger, :color, :attributes

    # rubocop:disable Metrics/AbcSize
    def configure
      logger.datetime_format = attributes.fetch :datetime_format, logger.datetime_format
      logger.level = attributes.fetch :level, default_level
      logger.progname = attributes.fetch :progname, logger.progname
      logger.formatter = attributes.fetch :formatter, default_formatter
    end
    # rubocop:enable Metrics/AbcSize

    def default_level = logger.class.const_get ENV.fetch("LOG_LEVEL", "INFO")

    def default_formatter
      -> severity, _at, _name, message { "#{color[message, severity.downcase]}\n" }
    end
  end
end
