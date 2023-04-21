# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Registry do
  subject(:registry) { Class.new { extend Cogger::Registry } }

  let :emojis do
    {
      debug: "🔎",
      info: "🟢",
      warn: "⚠️ ",
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
      color: [Cogger::Formatters::Color, nil],
      detail: [
        Cogger::Formatters::Simple,
        "[%<id>s] [%<severity>s] [%<at>s] %<message>s"
      ],
      emoji: [
        Cogger::Formatters::Color,
        "%<emoji:dynamic>s %<message:dynamic>s"
      ],
      json: [Cogger::Formatters::JSON, nil],
      simple: [Cogger::Formatters::Simple, nil],
      rack: [
        Cogger::Formatters::Simple,
        "[%<id>s] [%<severity>s] [%<at>s] %<verb>s %<status>s %<duration>s " \
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
        warn: "⚠️ ",
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
  end

  describe "#add_filter" do
    before { registry.filters.clear }

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

  describe "#filters" do
    it "answers default filters" do
      expect(registry.filters).to eq(Set[:_csrf, :password, :password_confirmation])
    end

    it "answers filters when they exist" do
      registry.filters.clear
      registry.add_filter(:one).add_filter(:two)

      expect(registry.filters).to eq(Set[:one, :two])
    end
  end

  describe "#add_formatter" do
    it "adds formatter (symbol)" do
      registry.add_formatter :test, Cogger::Formatters::Simple
      expect(registry.get_formatter(:test)).to eq([Cogger::Formatters::Simple, nil])
    end

    it "adds formatter (string)" do
      registry.add_formatter "test", Cogger::Formatters::Simple
      expect(registry.get_formatter(:test)).to eq([Cogger::Formatters::Simple, nil])
    end

    it "adds formatter with template" do
      registry.add_formatter "test", Cogger::Formatters::Simple, "%<messag>s"
      expect(registry.get_formatter(:test)).to eq([Cogger::Formatters::Simple, "%<messag>s"])
    end

    it "answers itself" do
      expect(registry.add_formatter(:test, "%<message>s")).to be_a(described_class)
    end
  end

  describe "#get_formatter" do
    before { registry.add_formatter :test, Cogger::Formatters::Simple }

    it "answers template for key (symbol)" do
      expect(registry.get_formatter(:test)).to eq([Cogger::Formatters::Simple, nil])
    end

    it "answers template for key (string)" do
      expect(registry.get_formatter("test")).to eq([Cogger::Formatters::Simple, nil])
    end
  end

  describe "#formatters" do
    it "answers default formatters" do
      expect(registry.formatters).to include(
        color: [Cogger::Formatters::Color, nil],
        detail: [Cogger::Formatters::Simple, "[%<id>s] [%<severity>s] [%<at>s] %<message>s"],
        emoji: [Cogger::Formatters::Color, "%<emoji:dynamic>s %<message:dynamic>s"],
        json: [Cogger::Formatters::JSON, nil],
        rack: [
          Cogger::Formatters::Simple,
          "[%<id>s] [%<severity>s] [%<at>s] %<verb>s %<status>s %<duration>s %<ip>s %<path>s " \
          "%<length>s %<params>s"
        ],
        simple: [Cogger::Formatters::Simple, nil]
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
        filters: Set[:_csrf, :password, :password_confirmation],
        color: kind_of(Tone::Client)
      )
    end
  end
end
