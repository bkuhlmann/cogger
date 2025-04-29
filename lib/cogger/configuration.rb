# frozen_string_literal: true

require "core"
require "logger"
require "refinements/array"

module Cogger
  # Defines the default configuration for all pipes.
  Configuration = Data.define(
    :id,
    :io,
    :level,
    :formatter,
    :datetime_format,
    :tags,
    :mode,
    :age,
    :size,
    :suffix,
    :entry,
    :logger
  ) do
    using Refinements::Array

    def initialize id: Program.call,
                   io: $stdout,
                   level: Level.call,
                   formatter: Formatters::Emoji.new,
                   datetime_format: DATETIME_FORMAT,
                   tags: Core::EMPTY_ARRAY,
                   mode: false,
                   age: nil,
                   size: 1_048_576,
                   suffix: "%Y-%m-%d",
                   entry: Entry,
                   logger: Logger
      super.tap { tags.freeze }
    end

    def entag(other = nil) = other ? tags.including(other) : tags

    def to_logger
      logger.new io,
                 age,
                 size,
                 progname: id,
                 level:,
                 formatter:,
                 datetime_format:,
                 binmode: mode,
                 shift_period_suffix: suffix
    end

    def inspect
      "#<#{self.class} @id=#{id}, @io=#{io.class}, @level=#{level}, " \
      "@formatter=#{formatter.class}, @datetime_format=#{datetime_format.inspect}, " \
      "@tags=#{tags.inspect}, @mode=#{mode}, @age=#{age}, @size=#{size}, " \
      "@suffix=#{suffix.inspect}, @entry=#{entry}, @logger=#{logger}>"
    end
  end
end
