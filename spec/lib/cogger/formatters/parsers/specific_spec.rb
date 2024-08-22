# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Specific do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with specific color" do
      expect(parser.call("%<one:cyan>s".dup, level: "info")).to have_color(
        color,
        ["%<one>s", :cyan]
      )
    end

    it "answers template with dynamic color" do
      expect(parser.call("%<one:dynamic>s".dup, level: "warn")).to have_color(
        color,
        ["%<one>s", :yellow]
      )
    end

    it "answers template with specific and dynamic colors" do
      expect(parser.call("%<one:cyan>s %<two:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%<one>s", :cyan],
        [" "],
        ["%<two>s", :green]
      )
    end

    it "answers template with space flag" do
      expect(parser.call("% <one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["% <one>s", :green]
      )
    end

    it "answers template with pound flag" do
      expect(parser.call("%#<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%#<one>s", :green]
      )
    end

    it "answers template with plus flag" do
      expect(parser.call("%+<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%+<one>s", :green]
      )
    end

    it "answers template with dash flag" do
      expect(parser.call("%-<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%-<one>s", :green]
      )
    end

    it "answers template with zero flag" do
      expect(parser.call("%0<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%0<one>s", :green]
      )
    end

    it "answers template with star flag" do
      expect(parser.call("%*<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%*<one>s", :green]
      )
    end

    it "doesn't parse dollar sign flag" do
      expect(parser.call("%$<one:dynamic>s".dup)).to eq("%$<one:dynamic>s")
    end

    it "answers template with width specifier" do
      expect(parser.call("%10<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%10<one>s", :green]
      )
    end

    it "answers template with precision specifier" do
      expect(parser.call("%.5<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%.5<one>s", :green]
      )
    end

    it "answers template with hexadecimal float type" do
      expect(parser.call("%<one:dynamic>a %<two:blue>A".dup, level: "info")).to have_color(
        color,
        ["%<one>a", :green],
        [" "],
        ["%<two>A", :blue]
      )
    end

    it "answers template with binary type" do
      expect(parser.call("%<one:dynamic>b %<two:blue>B".dup, level: "info")).to have_color(
        color,
        ["%<one>b", :green],
        [" "],
        ["%<two>B", :blue]
      )
    end

    it "answers template with character type" do
      expect(parser.call("%<one:dynamic>c".dup, level: "info")).to have_color(
        color,
        ["%<one>c", :green]
      )
    end

    it "answers template with integer type" do
      expect(parser.call("%<one:dynamic>d".dup, level: "info")).to have_color(
        color,
        ["%<one>d", :green]
      )
    end

    it "answers template with scientific notation type" do
      expect(parser.call("%<one:dynamic>e %<two:blue>E".dup, level: "info")).to have_color(
        color,
        ["%<one>e", :green],
        [" "],
        ["%<two>E", :blue]
      )
    end

    it "answers template with float type" do
      expect(parser.call("%<one:dynamic>f".dup, level: "info")).to have_color(
        color,
        ["%<one>f", :green]
      )
    end

    it "answers template with exponential type" do
      expect(parser.call("%<one:dynamic>g %<two:blue>G".dup, level: "info")).to have_color(
        color,
        ["%<one>g", :green],
        [" "],
        ["%<two>G", :blue]
      )
    end

    it "answers template with octal type" do
      expect(parser.call("%<one:dynamic>o".dup, level: "info")).to have_color(
        color,
        ["%<one>o", :green]
      )
    end

    it "answers template with string inspect type" do
      expect(parser.call("%<one:dynamic>p".dup, level: "info")).to have_color(
        color,
        ["%<one>p", :green]
      )
    end

    it "answers template with string cast type" do
      expect(parser.call("%<one:dynamic>s".dup, level: "info")).to have_color(
        color,
        ["%<one>s", :green]
      )
    end

    it "answers template with hexadecimal integer type" do
      expect(parser.call("%<one:dynamic>x %<two:blue>X".dup, level: "info")).to have_color(
        color,
        ["%<one>x", :green],
        [" "],
        ["%<two>X", :blue]
      )
    end

    it "answers template with no colors" do
      expect(parser.call("test".dup)).to eq("test")
    end
  end
end
