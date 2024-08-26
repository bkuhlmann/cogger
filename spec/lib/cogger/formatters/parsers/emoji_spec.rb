# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Emoji do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers template with dynamic emoji" do
      expect(parser.call("%<emoji:dynamic>s".dup, "INFO")).to eq("🟢")
    end

    it "answers template with specific emoji" do
      expect(parser.call("%<emoji:warn>s".dup, "INFO")).to eq("⚠️")
    end

    it "answers template with dynamic and specific emojis" do
      expect(parser.call("%<emoji:dynamic>s %<emoji:warn>s".dup, "INFO")).to eq("🟢 ⚠️")
    end

    it "answers template with no directives" do
      expect(parser.call("Test".dup, "INFO")).to eq("Test")
    end
  end
end
