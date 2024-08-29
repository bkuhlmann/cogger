# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Position do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:attributes) { {one: 1, two: 2, three: 3} }

    it "answers original key positions with nil template" do
      expect(parser.call(nil, attributes).keys).to eq(%i[one two three])
    end

    it "answers original key positions with empty template" do
      expect(parser.call("", attributes).keys).to eq(%i[one two three])
    end

    it "answers original key positions with template with no string specifiers" do
      expect(parser.call("This is a test.", attributes).keys).to eq(%i[one two three])
    end

    it "answers new key positions with single matching key" do
      expect(parser.call("%<three:dynamic>s", attributes).keys).to eq(%i[three one two])
    end

    it "answers new key positions with partial matching keys" do
      expect(parser.call("%<two>s %<three:dynamic>s", attributes).keys).to eq(%i[two three one])
    end

    it "answers new key positions based on directive positions" do
      template = "%<two:dynamic>s %<three:dynamic>s %<one:dynamic>s"
      expect(parser.call(template, attributes).keys).to eq(%i[two three one])
    end

    it "answers new key positions based on plain key positions" do
      template = "%<two>s %<three>s %<one>s"
      expect(parser.call(template, attributes).keys).to eq(%i[two three one])
    end

    it "answers new key positions based on mixed key positions" do
      template = "%<three:green>s %<two>s %<one:dynamic>s"
      expect(parser.call(template, attributes).keys).to eq(%i[three two one])
    end
  end
end
