# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Time::Span do
  subject(:timer) { described_class.new clock }

  let(:clock) { object_double Cogger::Time::Clock }

  describe "#call" do
    it "answers duration in nanoseconds" do
      allow(clock).to receive(:call).and_return(1, 2)
      result = timer.call { "test" }

      expect(result).to eq(["test", 1, "ns"])
    end

    it "answers duration in microseconds" do
      allow(clock).to receive(:call).and_return(1, 1_001)
      result = timer.call { "test" }

      expect(result).to eq(["test", 1, "µs"])
    end

    it "answers duration in milliseconds" do
      allow(clock).to receive(:call).and_return(1, 1_000_001)
      result = timer.call { "test" }

      expect(result).to eq(["test", 1, "ms"])
    end

    it "answers duration in seconds" do
      allow(clock).to receive(:call).and_return(1, 1_000_000_001)
      result = timer.call { "test" }

      expect(result).to eq(["test", 1, "s"])
    end

    it "answers duration in minutes" do
      allow(clock).to receive(:call).and_return(1, 60_000_000_001)
      result = timer.call { "test" }

      expect(result).to eq(["test", 1, "m"])
    end
  end
end
