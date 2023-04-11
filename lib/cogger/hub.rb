# frozen_string_literal: true

require "logger"
require "refinements/loggers"

module Cogger
  # Loads configuration and simultaneously sends messages to multiple streams.
  # :reek:TooManyInstanceVariables
  class Hub
    using Refinements::Loggers

    def initialize(registry: Cogger, model: Configuration.new, **attributes)
      @registry = registry
      @configuration = model.with(**transform(attributes))
      @primary = configuration.to_logger
      @streams = [@primary]
      @mutex = Mutex.new
    end

    def add_stream **attributes
      attributes[:id] = configuration.id
      streams.append configuration.with(**transform(attributes)).to_logger
      self
    end

    def debug(...) = log(__method__, ...)

    def info(...) = log(__method__, ...)

    def warn(...) = log(__method__, ...)

    def error(...) = log(__method__, ...)

    def fatal(...) = log(__method__, ...)

    def unknown(...) = log(__method__, ...)

    alias any unknown

    def reread = primary.reread

    def inspect
      %(#<#{self.class} #{configuration.inspect.delete_prefix! "#<Cogger::Configuration "})
    end

    private

    attr_reader :registry, :configuration, :primary, :streams, :mutex

    # :reek:FeatureEnvy
    # :reek:TooManyStatements
    def transform attributes
      value = attributes[:formatter]

      return attributes unless value.is_a?(Symbol) || value.is_a?(String)

      formatter, template = registry.get_formatter value
      attributes[:formatter] = template ? formatter.new(template) : formatter.new
      attributes
    end

    # :reek:TooManyStatements
    def log(severity, message = nil, &)
      mutex.synchronize { streams.each { |logger| logger.public_send(severity, message, &) } }
      true
    rescue StandardError => error
      configuration.with(id: "Cogger", io: $stdout, formatter: Formatters::Crash.new)
                   .to_logger
                   .fatal message:,
                          error_message: error.message,
                          error_class: error.class,
                          backtrace: error.backtrace
      true
    end
  end
end
