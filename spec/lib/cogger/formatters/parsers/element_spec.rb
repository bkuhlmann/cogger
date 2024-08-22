# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Element do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with specific color" do
      expect(parser.call("<cyan>one</cyan>".dup, level: "info")).to have_color(
        color,
        ["one", :cyan]
      )
    end

    it "answers template with dynamic color" do
      expect(parser.call("<dynamic>one</dynamic>".dup, level: "info")).to have_color(
        color,
        ["one", :green]
      )
    end

    it "answers template with dynamic color and string specifier" do
      expect(parser.call("<cyan>%<one>s</cyan>".dup, level: "info")).to have_color(
        color,
        ["%<one>s", :cyan]
      )
    end

    it "answers template with specific and dynamic colors" do
      template = "<cyan>one</cyan> <dynamic>two</dynamic> <blue>three</blue>".dup

      expect(parser.call(template, level: "info")).to have_color(
        color,
        ["one", :cyan],
        [" "],
        ["two", :green],
        [" "],
        ["three", :blue]
      )
    end

    it "answers template with inner color only" do
      template = "<cyan><dynamic>one</dynamic></cyan>".dup

      expect(parser.call(template, level: "info")).to have_color(
        color,
        ["<dynamic>one", :cyan],
        ["</cyan>"]
      )
    end

    it "answers template with color over multiple lines" do
      expect(parser.call("<cyan>\none\n</cyan>".dup, level: "info")).to have_color(
        color,
        ["\none\n", :cyan]
      )
    end

    it "answers template with no colors" do
      expect(parser.call("Test".dup, level: "info")).to eq("Test")
    end
  end
end
