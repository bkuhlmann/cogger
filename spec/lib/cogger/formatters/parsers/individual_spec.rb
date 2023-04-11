# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Individual do
  subject(:parser) { described_class.new }

  describe "#call" do
    it "answers template with no matches" do
      template = "<dynamic>test</dynamic>"
      expect(parser.call(template)).to eq([template, {}])
    end

    it "answers template and nil valued directives with no directives" do
      template = "<dynamic>%<message>s</dynamic>"
      expect(parser.call(template)).to eq([template, {message: nil}])
    end

    it "answers template with directive hash" do
      template = "%<severity:dynamic>s %<message:white>s"

      expect(parser.call(template)).to eq(
        [
          "%<severity>s %<message>s",
          {severity: "dynamic", message: "white"}
        ]
      )
    end

    it "parses space flag template" do
      template = "% <one:green>s"
      expect(parser.call(template)).to eq(["% <one>s", {one: "green"}])
    end

    it "parses pound flag template" do
      template = "%#<one:green>s"
      expect(parser.call(template)).to eq(["%#<one>s", {one: "green"}])
    end

    it "parses plus flag template" do
      template = "%+<one:green>s"
      expect(parser.call(template)).to eq(["%+<one>s", {one: "green"}])
    end

    it "parses dash flag template" do
      template = "%-<one:green>s"
      expect(parser.call(template)).to eq(["%-<one>s", {one: "green"}])
    end

    it "parses zero flag template" do
      template = "%0<one:green>s"
      expect(parser.call(template)).to eq(["%0<one>s", {one: "green"}])
    end

    it "parses star flag template" do
      template = "%*<one:green>s"
      expect(parser.call(template)).to eq(["%*<one>s", {one: "green"}])
    end

    it "does not parse dollar sign flag template" do
      template = "%$<one:green>s"
      expect(parser.call(template)).to eq(["%$<one:green>s", {}])
    end

    it "parses width specifier template" do
      template = "%10<one:green>s"
      expect(parser.call(template)).to eq(["%10<one>s", {one: "green"}])
    end

    it "parses precision specifier template" do
      template = "%.5<one:green>s"
      expect(parser.call(template)).to eq(["%.5<one>s", {one: "green"}])
    end

    it "parses hexadecimal float typed template" do
      template = "%<one:green>a %<two:blue>A"
      expect(parser.call(template)).to eq(["%<one>a %<two>A", {one: "green", two: "blue"}])
    end

    it "parses binary typed template" do
      template = "%<one:green>b %<two:blue>B"
      expect(parser.call(template)).to eq(["%<one>b %<two>B", {one: "green", two: "blue"}])
    end

    it "parses character typed template" do
      template = "%<one:green>c"
      expect(parser.call(template)).to eq(["%<one>c", {one: "green"}])
    end

    it "parses integer typed template" do
      template = "%<one:green>d"
      expect(parser.call(template)).to eq(["%<one>d", {one: "green"}])
    end

    it "parses scientific notation typed template" do
      template = "%<one:green>e %<two:blue>E"
      expect(parser.call(template)).to eq(["%<one>e %<two>E", {one: "green", two: "blue"}])
    end

    it "parses float typed template" do
      template = "%<one:green>f"
      expect(parser.call(template)).to eq(["%<one>f", {one: "green"}])
    end

    it "parses exponential typed template" do
      template = "%<one:green>g %<two:blue>G"
      expect(parser.call(template)).to eq(["%<one>g %<two>G", {one: "green", two: "blue"}])
    end

    it "parses octal typed template" do
      template = "%<one:green>o"
      expect(parser.call(template)).to eq(["%<one>o", {one: "green"}])
    end

    it "parses string inspect typed template" do
      template = "%<one:green>p"
      expect(parser.call(template)).to eq(["%<one>p", {one: "green"}])
    end

    it "parses string cast typed template" do
      template = "%<one:green>s"
      expect(parser.call(template)).to eq(["%<one>s", {one: "green"}])
    end

    it "parses hexadecimal integer typed template" do
      template = "%<one:green>x %<two:blue>X"
      expect(parser.call(template)).to eq(["%<one>x %<two>X", {one: "green", two: "blue"}])
    end
  end
end
