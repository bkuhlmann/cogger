# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Element do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with dynamic color" do
      expect(parser.call("<dynamic>one</dynamic>".dup, "INFO")).to have_color(
        color,
        ["one", :green]
      )
    end

    it "answers template with specific color" do
      expect(parser.call("<cyan>one</cyan>".dup, "INFO")).to have_color(color, ["one", :cyan])
    end

    it "answers template with dynamic color and string specifier" do
      expect(parser.call("<cyan>%<one>s</cyan>".dup, "INFO")).to have_color(
        color,
        ["%<one>s", :cyan]
      )
    end

    it "answers template with dynamic and specific colors" do
      template = "<dynamic>one</dynamic> <cyan>two</cyan>".dup

      expect(parser.call(template, "INFO")).to have_color(
        color,
        ["one", :green],
        [" "],
        ["two", :cyan]
      )
    end

    it "answers template with inner color only" do
      template = "<cyan><dynamic>one</dynamic></cyan>".dup

      expect(parser.call(template, "INFO")).to have_color(
        color,
        ["<dynamic>one", :cyan],
        ["</cyan>"]
      )
    end

    it "answers template with color over multiple lines" do
      expect(parser.call("<cyan>\none\n</cyan>".dup, "INFO")).to have_color(
        color,
        ["\none\n", :cyan]
      )
    end

    it "answers template with no directives" do
      expect(parser.call("Test".dup, "INFO")).to eq("Test")
    end
  end
end
