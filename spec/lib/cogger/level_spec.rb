# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Level do
  subject(:level) { described_class }

  let(:environment) { {} }

  describe "#call" do
    it "answers default level" do
      expect(level.call(environment:)).to eq(1)
    end

    it "answers custom level" do
      environment["LOG_LEVEL"] = "DEBUG"
      expect(level.call(environment:)).to eq(0)
    end

    it "answers custom level after being sanitized" do
      environment["LOG_LEVEL"] = "debug"
      expect(level.call(environment:)).to eq(0)
    end

    it "fails with invalid log level" do
      environment["LOG_LEVEL"] = "bogus"
      expectation = proc { level.call environment: }

      expect(&expectation).to raise_error(
        ArgumentError,
        %(Invalid log level: "bogus". Use: "debug", "info", "warn", "error", "fatal", or "unknown".)
      )
    end
  end
end
