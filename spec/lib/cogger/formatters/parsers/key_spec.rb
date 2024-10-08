# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Key do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with dynamic color" do
      expect(parser.call("%<one:dynamic>s".dup, "WARN")).to have_color(
        color,
        ["%<one>s", :yellow]
      )
    end

    it "answers template with specific color" do
      expect(parser.call("%<one:cyan>s".dup, "INFO")).to have_color(color, ["%<one>s", :cyan])
    end

    it "answers template with dynamic and specific colors" do
      expect(parser.call("%<one:dynamic>s %<two:cyan>s".dup, "INFO")).to have_color(
        color,
        ["%<one>s", :green],
        [" "],
        ["%<two>s", :cyan]
      )
    end

    it "answers template with space flag" do
      expect(parser.call("% <one:dynamic>d".dup, "INFO")).to have_color(
        color,
        ["% <one>d", :green]
      )
    end

    it "answers template with pound flag" do
      expect(parser.call("%#<one:dynamic>x".dup, "INFO")).to have_color(
        color,
        ["%#<one>x", :green]
      )
    end

    it "answers template with plus flag" do
      expect(parser.call("%+<one:dynamic>x".dup, "INFO")).to have_color(
        color,
        ["%+<one>x", :green]
      )
    end

    it "answers template with dash flag" do
      expect(parser.call("%-<one:dynamic>d".dup, "INFO")).to have_color(
        color,
        ["%-<one>d", :green]
      )
    end

    it "answers template with zero flag" do
      expect(parser.call("%0<one:dynamic>d".dup, "INFO")).to have_color(
        color,
        ["%0<one>d", :green]
      )
    end

    it "answers template with star flag" do
      expect(parser.call("%*<one:dynamic>d".dup, "INFO")).to have_color(
        color,
        ["%*<one>d", :green]
      )
    end

    it "doesn't parse dollar sign flag (position)" do
      expect(parser.call("%1$s".dup, "INFO")).to eq("%1$s")
    end

    it "doesn't parse dollar sign flag (key)" do
      expect(parser.call("%$<one:dynamic>s".dup, "INFO")).to eq("%$<one:dynamic>s")
    end

    it "answers template with positive width specifier" do
      expect(parser.call("%10<one:dynamic>s".dup, "INFO")).to have_color(
        color,
        ["%10<one>s", :green]
      )
    end

    it "answers template with negative width specifier" do
      expect(parser.call("%-10<one:dynamic>s".dup, "INFO")).to have_color(
        color,
        ["%-10<one>s", :green]
      )
    end

    it "answers template with precision specifier" do
      expect(parser.call("%.5<one:dynamic>d".dup, "INFO")).to have_color(
        color,
        ["%.5<one>d", :green]
      )
    end

    it "answers template with hexadecimal float type" do
      expect(parser.call("%<one:dynamic>a %<two:blue>A".dup, "INFO")).to have_color(
        color,
        ["%<one>a", :green],
        [" "],
        ["%<two>A", :blue]
      )
    end

    it "answers template with binary type" do
      expect(parser.call("%<one:dynamic>b %<two:blue>B".dup, "INFO")).to have_color(
        color,
        ["%<one>b", :green],
        [" "],
        ["%<two>B", :blue]
      )
    end

    it "answers template with character type" do
      expect(parser.call("%<one:dynamic>c".dup, "INFO")).to have_color(color, ["%<one>c", :green])
    end

    it "answers template with integer type" do
      expect(parser.call("%<one:dynamic>d".dup, "INFO")).to have_color(color, ["%<one>d", :green])
    end

    it "answers template with scientific notation type" do
      expect(parser.call("%<one:dynamic>e %<two:blue>E".dup, "INFO")).to have_color(
        color,
        ["%<one>e", :green],
        [" "],
        ["%<two>E", :blue]
      )
    end

    it "answers template with float type" do
      expect(parser.call("%<one:dynamic>f".dup, "INFO")).to have_color(color, ["%<one>f", :green])
    end

    it "answers template with exponential type" do
      expect(parser.call("%<one:dynamic>g %<two:blue>G".dup, "INFO")).to have_color(
        color,
        ["%<one>g", :green],
        [" "],
        ["%<two>G", :blue]
      )
    end

    it "answers template with octal type" do
      expect(parser.call("%<one:dynamic>o".dup, "INFO")).to have_color(color, ["%<one>o", :green])
    end

    it "answers template with string inspect type" do
      expect(parser.call("%<one:dynamic>p".dup, "INFO")).to have_color(color, ["%<one>p", :green])
    end

    it "answers template with string cast type" do
      expect(parser.call("%<one:dynamic>s".dup, "INFO")).to have_color(color, ["%<one>s", :green])
    end

    it "answers template with hexadecimal integer type" do
      expect(parser.call("%<one:dynamic>x %<two:blue>X".dup, "INFO")).to have_color(
        color,
        ["%<one>x", :green],
        [" "],
        ["%<two>X", :blue]
      )
    end

    it "answers template with no directive" do
      expect(parser.call("test".dup, "INFO")).to eq("test")
    end
  end
end
