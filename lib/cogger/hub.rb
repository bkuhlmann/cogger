# frozen_string_literal: true

require "forwardable"
require "logger"
require "refinements/hash"

module Cogger
  # Loads configuration and simultaneously sends messages to multiple streams.
  class Hub
    extend Forwardable

    using Refinements::Hash
    using Refines::Logger

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
      level
      level=
    ] => :primary

    delegate %i[id io tags mode age size suffix] => :configuration

    def initialize registry: Cogger, model: Configuration, **attributes
      @registry = registry
      @configuration = model[**resolve_formatter(attributes)]
      @primary = configuration.to_logger
      @streams = [@primary]
    end

    def add_stream **attributes
      attributes[:id] = configuration.id
      streams.append configuration.with(**resolve_formatter(attributes)).to_logger
      self
    end

    def debug(message = nil, **, &) = log(__method__, message, **, &)

    def info(message = nil, **, &) = log(__method__, message, **, &)

    def warn(message = nil, **, &) = log(__method__, message, **, &)

    def error(message = nil, **, &) = log(__method__, message, **, &)

    def fatal(message = nil, **, &) = log(__method__, message, **, &)

    def any(message = nil, **, &) = log(__method__, message, **, &)

    def abort message = nil, **payload, &block
      error(message, **payload, &block) if message || !payload.empty? || block
      exit false
    end

    def panic message = nil, **payload, &block
      fatal(message, **payload, &block) if message || !payload.empty? || block
      exit false
    end

    def formatter= value
      primary.formatter = find_or_use_formatter value
    end

    def add(level, message = nil, **, &)
      log(Logger::SEV_LABEL.fetch(level, "ANY").downcase, message, **, &)
    end

    alias unknown any

    def reread = primary.reread

    def inspect
      %(#<#{self.class} #{configuration.inspect.delete_prefix! "#<Cogger::Configuration "})
    end

    private

    attr_reader :registry, :configuration, :primary, :streams

    def resolve_formatter attributes
      attributes.transform_value!(:formatter) { |value| find_or_use_formatter value }
    end

    def find_or_use_formatter value
      case value
        when String, Symbol
          formatter, template = registry.get_formatter value
          template ? formatter.new(template) : formatter.new
        when Formatters::Abstract then value
        else fail TypeError,
                  "Invalid formatter. Must be a string, symbol, or " \
                  "subclass of Cogger::Formatters::Abstract."
      end
    end

    def log(level, message = nil, **, &)
      dispatch(level, message, **, &)
    rescue StandardError => error
      crash message, error
    end

    def dispatch(level, message, **payload, &)
      entry = build_entry(level, message, payload, &)
      configuration.mutex.synchronize { streams.each { |logger| logger.public_send level, entry } }
      true
    end

    def build_entry(level, message, payload, &)
      configuration.entry.for(
        message,
        id: configuration.id,
        level:,
        tags: configuration.entag(payload[:tags]),
        datetime_format: configuration.datetime_format,
        **payload.except(:level, :at, :tags),
        &
      )
    end

    def crash message, error
      configuration.with(id: :cogger, io: $stdout, formatter: Formatters::Crash.new)
                   .to_logger
                   .fatal configuration.entry.for_crash(message, error, id: configuration.id)
      true
    end
  end
end
