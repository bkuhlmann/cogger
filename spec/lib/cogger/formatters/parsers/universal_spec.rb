# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Universal do
  subject(:parser) { described_class.new }

  describe "#call" do
    it "answers sanitized template (plain) and directive when matching" do
      expect(parser.call("<dynamic>test</dynamic>")).to eq(%w[test dynamic])
    end

    it "answers sanitized template (keyed) and directive when matching" do
      content = "<dynamic>%<message>s</dynamic>"
      expect(parser.call(content)).to eq(["%<message>s", "dynamic"])
    end

    it "answers template when not matching" do
      content = "%<severity:dynamic>s"
      expect(parser.call(content)).to eq(content)
    end
  end
end
