# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Emoji do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with specific emoji" do
      expect(parser.call("%<emoji:warn>s".dup, level: "info")).to eq("⚠️")
    end

    it "answers template with dynamic emoji" do
      expect(parser.call("%<emoji:dynamic>s".dup, level: "info")).to eq("🟢")
    end

    it "answers template with specific and dynamic emojis" do
      expect(parser.call("%<emoji:warn>s %<emoji:dynamic>s".dup, level: "info")).to eq("⚠️ 🟢")
    end

    it "answers template with no emojis" do
      expect(parser.call("Test".dup, level: "info")).to eq("Test")
    end
  end
end
