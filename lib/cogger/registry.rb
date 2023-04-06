# frozen_string_literal: true

require "tone"

module Cogger
  # Provides a global regsitry for global configuration.
  module Registry
    def self.extended target
      target.add_alias(:debug, :white)
            .add_alias(:info, :green)
            .add_alias(:warn, :yellow)
            .add_alias(:error, :red)
            .add_alias(:fatal, *%i[bold white on_red])
            .add_alias(:unknown, *%i[bold white])
            .add_alias(:any, *%i[bold white])
            .add_emoji(:debug, "🔎")
            .add_emoji(:info, "🟢")
            .add_emoji(:warn, "⚠️ ")
            .add_emoji(:error, "🛑")
            .add_emoji(:fatal, "🔥")
            .add_filter(:_csrf)
            .add_filter(:password)
            .add_filter(:password_confirmation)
            .add_formatter(:color, Cogger::Formatters::Color)
            .add_formatter(
              :detail,
              Cogger::Formatters::Simple,
              "[%<id>s] [%<severity>s] [%<at>s] %<message>s"
            )
            .add_formatter(
              :emoji,
              Cogger::Formatters::Color,
              "%<emoji:dynamic>s %<message:dynamic>s"
            )
            .add_formatter(:json, Cogger::Formatters::JSON)
            .add_formatter(:simple, Cogger::Formatters::Simple)
            .add_formatter :rack,
                           Cogger::Formatters::Simple,
                           "[%<id>s] [%<severity>s] [%<at>s] %<verb>s %<status>s %<duration>s " \
                           "%<ip>s %<path>s %<length>s %<params>s"
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

    def get_emoji(key) = emojis[key.to_sym]

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

    def get_formatter(key) = formatters[key.to_sym]

    def formatters = @formatters ||= {}

    def color = @color ||= Tone.new

    def defaults = {emojis: emojis.dup, formatters: formatters.dup}
  end
end
