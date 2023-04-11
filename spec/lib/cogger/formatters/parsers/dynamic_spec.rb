# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Dynamic do
  subject(:parser) { described_class.new }

  describe "#call" do
    it "answers universal template and directive" do
      result = parser.call "<dynamic>%<message>s</dynamic>"
      expect(result).to contain_exactly("%<message>s", "dynamic")
    end

    it "answers individual template and directives" do
      result = parser.call "%<severity:dynamic>s %<message:white>s"

      expect(result).to contain_exactly(
        "%<severity>s %<message>s",
        {severity: "dynamic", message: "white"}
      )
    end

    it "answers template and empty directives with no matches" do
      expect(parser.call("test")).to eq(["test", {}])
    end
  end
end
