# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Registry do
  subject(:registry) { Class.new { extend Cogger::Registry } }

  let :emojis do
    {
      debug: "🔎",
      info: "🟢",
      warn: "⚠️",
      error: "🛑",
      fatal: "🔥",
      any: "⚫️"
    }
  end

  let :aliases do
    {
      debug: [:white],
      info: [:green],
      warn: [:yellow],
      error: [:red],
      fatal: %i[bold white on_red],
      any: %i[dim bright_white]
    }
  end

  let :formatters do
    {
      color: [Cogger::Formatters::Color, "<dynamic>[%<id>s]</dynamic> %<message:dynamic>s"],
      detail: [Cogger::Formatters::Simple, "[%<id>s] [%<level>s] [%<at>s] %<message>s"],
      emoji: [
        Cogger::Formatters::Emoji,
        "%<emoji:dynamic>s <dynamic>[%<id>s]</dynamic> %<message:dynamic>s"
      ],
      json: [Cogger::Formatters::JSON, nil],
      property: [Cogger::Formatters::Property, nil],
      simple: [Cogger::Formatters::Simple, "[%<id>s] %<message>s"],
      rack: [
        Cogger::Formatters::Simple,
        "[%<id>s] [%<level>s] [%<at>s] %<verb>s %<status>s %<duration>s " \
        "%<ip>s %<path>s %<length>s %<params>s"
      ]
    }
  end

  describe ".extended" do
    it "adds default aliases" do
      expect(registry.color.aliases).to eq(
        debug: [:white],
        info: [:green],
        warn: [:yellow],
        error: [:red],
        fatal: %i[bold white on_red],
        any: %i[dim bright_white]
      )
    end

    it "adds default emojis" do
      expect(registry.defaults.fetch(:emojis)).to eq(emojis)
    end

    it "adds default formatters" do
      expect(registry.defaults.fetch(:formatters)).to eq(formatters)
    end

    it "answers default emojis" do
      expect(registry.emojis).to eq(
        debug: "🔎",
        info: "🟢",
        warn: "⚠️",
        error: "🛑",
        fatal: "🔥",
        any: "⚫️"
      )
    end
  end

  describe "#add_alias" do
    it "adds alias" do
      registry.add_alias :test, :green
      expect(registry.color.aliases).to include(test: [:green])
    end

    it "answers itself" do
      expect(registry.add_alias(:test, :green)).to be_a(described_class)
    end
  end

  describe "#aliases" do
    it "answers default aliases" do
      expect(registry.aliases).to eq(
        debug: [:white],
        info: [:green],
        warn: [:yellow],
        error: [:red],
        fatal: %i[bold white on_red],
        any: %i[dim bright_white]
      )
    end
  end

  describe "#add_emoji" do
    it "adds emoji (symbol)" do
      registry.add_emoji :test, "🧪"
      expect(registry.get_emoji(:test)).to eq("🧪")
    end

    it "adds emoji (string)" do
      registry.add_emoji "test", "🧪"
      expect(registry.get_emoji(:test)).to eq("🧪")
    end

    it "answers itself" do
      expect(registry.add_emoji(:test, "🧪")).to be_a(described_class)
    end
  end

  describe "#get_emoji" do
    before { registry.add_emoji :test, "🧪" }

    it "answers template for key (symbol)" do
      expect(registry.get_emoji(:test)).to eq("🧪")
    end

    it "answers template for key (string)" do
      expect(registry.get_emoji("test")).to eq("🧪")
    end

    it "fails when not registered" do
      expectation = proc { registry.get_emoji :bogus }
      expect(&expectation).to raise_error(KeyError, "Unregistered emoji: bogus.")
    end
  end

  describe "#add_filter" do
    before { registry.filters.clear }

    it "prints deprecation warning" do
      expectation = proc { registry.add_filter :test }
      message = "`Class#add_filter` is deprecated, use `#add_filters` instead.\n"

      expect(&expectation).to output(message).to_stderr
    end

    it "adds filter (symbol)" do
      registry.add_filter :test
      expect(registry.filters).to eq(Set[:test])
    end

    it "adds filter (string)" do
      registry.add_filter "test"
      expect(registry.filters).to eq(Set[:test])
    end

    it "answers itself" do
      expect(registry.add_filter(:test)).to be_a(described_class)
    end
  end

  describe "#add_filters" do
    before { registry.filters.clear }

    it "adds mixed filters (symbol and string)" do
      registry.add_filters :one, "two"
      expect(registry.filters).to eq(Set[:one, :two])
    end

    it "answers itself" do
      expect(registry.add_filters(:test)).to be_a(described_class)
    end
  end

  describe "#filters" do
    it "answers default filters" do
      expect(registry.filters).to eq(Set.new)
    end

    it "answers filters when they exist" do
      registry.filters.clear
      registry.add_filters :one, :two

      expect(registry.filters).to eq(Set[:one, :two])
    end
  end

  describe "#add_formatter" do
    it "adds formatter (symbol)" do
      registry.add_formatter :test, Cogger::Formatters::Simple

      expect(registry.get_formatter(:test)).to eq(
        [Cogger::Formatters::Simple, "[%<id>s] %<message>s"]
      )
    end

    it "adds formatter (string)" do
      registry.add_formatter "test", Cogger::Formatters::Simple

      expect(registry.get_formatter(:test)).to eq(
        [Cogger::Formatters::Simple, "[%<id>s] %<message>s"]
      )
    end

    it "adds formatter with template" do
      registry.add_formatter "test", Cogger::Formatters::Simple, "%<messag>s"
      expect(registry.get_formatter(:test)).to eq([Cogger::Formatters::Simple, "%<messag>s"])
    end

    it "fails when formatter doesn't have a default template" do
      expectation = proc { registry.add_formatter :test, Object }

      expect(&expectation).to raise_error(
        NameError,
        "Object::TEMPLATE must be defined with a default template string."
      )
    end

    it "answers itself" do
      expect(registry.add_formatter(:test, Cogger::Formatters::Simple)).to be_a(described_class)
    end
  end

  describe "#get_formatter" do
    before { registry.add_formatter :test, Cogger::Formatters::Simple }

    it "answers template for key (symbol)" do
      expect(registry.get_formatter(:test)).to eq(
        [Cogger::Formatters::Simple, "[%<id>s] %<message>s"]
      )
    end

    it "answers template for key (string)" do
      expect(registry.get_formatter("test")).to eq(
        [Cogger::Formatters::Simple, "[%<id>s] %<message>s"]
      )
    end

    it "fails when not registered" do
      expectation = proc { registry.get_formatter :bogus }
      expect(&expectation).to raise_error(KeyError, "Unregistered formatter: bogus.")
    end
  end

  describe "#formatters" do
    it "answers default formatters" do
      expect(registry.formatters).to include(
        color: [Cogger::Formatters::Color, "<dynamic>[%<id>s]</dynamic> %<message:dynamic>s"],
        detail: [Cogger::Formatters::Simple, "[%<id>s] [%<level>s] [%<at>s] %<message>s"],
        emoji: [
          Cogger::Formatters::Emoji,
          "%<emoji:dynamic>s <dynamic>[%<id>s]</dynamic> %<message:dynamic>s"
        ],
        json: [Cogger::Formatters::JSON, nil],
        rack: [
          Cogger::Formatters::Simple,
          "[%<id>s] [%<level>s] [%<at>s] %<verb>s %<status>s %<duration>s %<ip>s %<path>s " \
          "%<length>s %<params>s"
        ],
        simple: [Cogger::Formatters::Simple, "[%<id>s] %<message>s"]
      )
    end
  end

  describe "#templates" do
    it "answers default templates" do
      expect(registry.templates).to include(
        color: "<dynamic>[%<id>s]</dynamic> %<message:dynamic>s",
        detail: "[%<id>s] [%<level>s] [%<at>s] %<message>s",
        emoji: "%<emoji:dynamic>s <dynamic>[%<id>s]</dynamic> %<message:dynamic>s",
        json: nil,
        rack: "[%<id>s] [%<level>s] [%<at>s] %<verb>s %<status>s %<duration>s %<ip>s %<path>s " \
              "%<length>s %<params>s",
        simple: "[%<id>s] %<message>s"
      )
    end
  end

  describe "#color" do
    it "answers color instance" do
      expect(registry.color).to be_a(Tone::Client)
    end
  end

  describe "#defaults" do
    it "answers defaults" do
      expect(registry.defaults).to match(
        emojis:,
        aliases:,
        formatters:,
        filters: Set.new,
        color: kind_of(Tone::Client)
      )
    end
  end
end
