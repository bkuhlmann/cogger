# frozen_string_literal: true

require "logger"

module Cogger
  # Defines the default configuration for all pipes.
  Configuration = Data.define(
    :id,
    :io,
    :level,
    :formatter,
    :tags,
    :mode,
    :age,
    :size,
    :suffix,
    :entry,
    :logger
  ) do
    def initialize id: Program.call,
                   io: $stdout,
                   level: Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO")),
                   formatter: Formatters::Emoji.new,
                   tags: [],
                   mode: false,
                   age: 0,
                   size: 1_048_576,
                   suffix: "%Y-%m-%d",
                   entry: Entry,
                   logger: Logger
      super
    end

    def to_logger
      logger.new io,
                 age,
                 size,
                 progname: id,
                 level:,
                 formatter:,
                 binmode: mode,
                 shift_period_suffix: suffix
    end

    def inspect
      "#<#{self.class} @id=#{id}, @io=#{io.class}, @level=#{level}, " \
      "@formatter=#{formatter.class}, @tags=#{tags.inspect}, " \
      "@mode=#{mode}, @age=#{age}, @size=#{size}, @suffix=#{suffix.inspect}, " \
      "@entry=#{entry}, @logger=#{logger}>"
    end
  end
end
