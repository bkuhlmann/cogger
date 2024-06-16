# frozen_string_literal: true

require "tone"

module Cogger
  # Provides a global regsitry for global configuration.
  module Registry
    def self.extended descendant
      descendant.add_alias(:debug, :white)
                .add_alias(:info, :green)
                .add_alias(:warn, :yellow)
                .add_alias(:error, :red)
                .add_alias(:fatal, :bold, :white, :on_red)
                .add_alias(:any, :dim, :bright_white)
                .add_emoji(:debug, "🔎")
                .add_emoji(:info, "🟢")
                .add_emoji(:warn, "⚠️")
                .add_emoji(:error, "🛑")
                .add_emoji(:fatal, "🔥")
                .add_emoji(:any, "⚫️")
                .add_formatter(:color, Cogger::Formatters::Color)
                .add_formatter(
                  :detail,
                  Cogger::Formatters::Simple,
                  "[%<id>s] [%<severity>s] [%<at>s] %<message>s"
                )
                .add_formatter(:emoji, Cogger::Formatters::Emoji)
                .add_formatter(:json, Cogger::Formatters::JSON)
                .add_formatter(:simple, Cogger::Formatters::Simple)
                .add_formatter :rack,
                               Cogger::Formatters::Simple,
                               "[%<id>s] [%<severity>s] [%<at>s] %<verb>s %<status>s " \
                               "%<duration>s %<ip>s %<path>s %<length>s %<params>s"
    end

    def add_alias(key, *styles)
      color.add_alias(key, *styles)
      self
    end

    def aliases = color.aliases

    def add_emoji key, value
      emojis[key.to_sym] = value
      self
    end

    def get_emoji key
      emojis.fetch(key.to_sym) { fail KeyError, "Unregistered emoji: #{key}." }
    end

    def emojis = @emojis ||= {}

    def add_filter key
      filters.add key.to_sym
      self
    end

    def filters = @filters ||= Set.new

    def add_formatter key, formatter, template = nil
      formatters[key.to_sym] = [formatter, template]
      self
    end

    def get_formatter key
      formatters.fetch(key.to_sym) { fail KeyError, "Unregistered formatter: #{key}." }
    end

    def formatters = @formatters ||= {}

    def color = @color ||= Tone.new

    def defaults = {emojis:, aliases:, formatters:, filters:, color:}
  end
end
