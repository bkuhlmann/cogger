# frozen_string_literal: true

require "forwardable"
require "logger"
require "refinements/hashes"
require "refinements/loggers"

module Cogger
  # Loads configuration and simultaneously sends messages to multiple streams.
  # :reek:TooManyInstanceVariables
  class Hub
    extend Forwardable

    using Refinements::Loggers
    using Refinements::Hashes

    delegate %i[
      close
      reopen
      debug!
      debug?
      info!
      info?
      warn!
      warn?
      error!
      error?
      fatal!
      fatal?
      formatter
      formatter=
      level
      level=
    ] => :primary

    def initialize(registry: Cogger, model: Configuration, **attributes)
      @registry = registry
      @configuration = model[**find_formatter(attributes)]
      @primary = configuration.to_logger
      @streams = [@primary]
      @mutex = Mutex.new
    end

    def add_stream **attributes
      attributes[:id] = configuration.id
      streams.append configuration.with(**find_formatter(attributes)).to_logger
      self
    end

    def debug(message = nil, **payload, &) = log(__method__, message, **payload, &)

    def info(message = nil, **payload, &) = log(__method__, message, **payload, &)

    def warn(message = nil, **payload, &) = log(__method__, message, **payload, &)

    def error(message = nil, **payload, &) = log(__method__, message, **payload, &)

    def fatal(message = nil, **payload, &) = log(__method__, message, **payload, &)

    def any(message = nil, **payload, &) = log(__method__, message, **payload, &)

    alias unknown any

    def reread = primary.reread

    def inspect
      %(#<#{self.class} #{configuration.inspect.delete_prefix! "#<Cogger::Configuration "})
    end

    private

    attr_reader :registry, :configuration, :primary, :streams, :mutex

    def find_formatter attributes
      attributes.transform_with!(
        formatter: lambda do |value|
          return value unless value.is_a?(Symbol) || value.is_a?(String)

          formatter, template = registry.get_formatter value
          template ? formatter.new(template) : formatter.new
        end
      )
    end

    def log(severity, message, **payload, &)
      dispatch(severity, message, **payload, &)
    rescue StandardError => error
      crash message, error
    end

    def dispatch(severity, message, **payload, &)
      entry = configuration.entry.for(message, id: configuration.id, severity:, **payload, &)
      mutex.synchronize { streams.each { |logger| logger.public_send severity, entry } }
      true
    end

    def crash message, error
      configuration.with(id: :cogger, io: $stdout, formatter: Formatters::Crash.new)
                   .to_logger
                   .fatal configuration.entry.for_crash(message, error, id: configuration.id)
      true
    end
  end
end
