# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Combined do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    let :proof do
      [
        ["🔎 🔥 "],
        ["%<one>s", :cyan],
        [" "],
        ["%<two>s", :white],
        [" "],
        ["three", :yellow],
        [" "],
        ["four", :white]
      ]
    end

    it "answers template with literals, emojis, and keys with specific and dynamic colors" do
      template = "%<emoji:dynamic>s %<emoji:fatal>s %<one:cyan>s %<two:dynamic>s " \
                 "<yellow>three</yellow> " \
                 "<dynamic>four</dynamic>"

      expect(parser.call(template, level: "debug")).to have_color(color, *proof)
    end

    it "answers template with no colors" do
      expect(parser.call("Test".dup, level: "info")).to eq("Test")
    end
  end
end