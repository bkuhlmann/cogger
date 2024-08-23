# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::KeyExtractor do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers single key" do
      expect(parser.call("%<one:cyan>s")).to eq([:one])
    end

    it "answers single key with left padding" do
      expect(parser.call("%06d<one:dynamic>s")).to eq([:one])
    end

    it "answers single key with precision" do
      expect(parser.call("%.5d<one:dynamic>s")).to eq([:one])
    end

    it "answers multiple keys" do
      expect(parser.call("%<one:cyan>s %<two:dynamic>s %<three>s")).to eq(%i[one two three])
    end

    it "answers empty array with no keys found" do
      expect(parser.call("test".dup)).to eq([])
    end
  end
end
