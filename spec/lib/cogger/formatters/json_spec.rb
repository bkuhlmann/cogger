# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::JSON do
  subject(:formatter) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }

    it "answers JSON with default template and message string" do
      expect(formatter.call("INFO", at, :test, "test")).to eq(
        %(#{{id: "test", severity: "INFO", at:, message: "test"}.to_json}\n)
      )
    end

    it "answers JSON with default template and message hash" do
      expect(formatter.call("INFO", at, :test, verb: "GET", path: "/")).to eq(
        %(#{{id: "test", severity: "INFO", at:, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers JSON with default template and no message" do
      expect(formatter.call("INFO", at, :test)).to eq(
        %(#{{id: "test", severity: "INFO", at:, message: nil}.to_json}\n)
      )
    end

    it "answers JSON with custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<severity>s %<id>s"
      expect(formatter.call("INFO", at, :test, verb: "GET", path: "/")).to eq(
        %(#{{path: "/", verb: "GET", at:, severity: "INFO", id: "test"}.to_json}\n)
      )
    end

    it "answers JSON with custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<severity>s"
      expect(formatter.call("INFO", at, :test, verb: "GET", path: "/")).to eq(
        %(#{{at:, id: "test", severity: "INFO", verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers JSON with custom template using invalid keys and message hash" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"
      expect(formatter.call("INFO", at, :test, verb: "GET", path: "/")).to eq(
        %(#{{id: "test", severity: "INFO", at:, verb: "GET", path: "/"}.to_json}\n)
      )
    end
  end
end
