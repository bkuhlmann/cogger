# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Time::Unit do
  subject(:unit) { described_class }

  describe "#call" do
    it "answers nanoseconds" do
      expect(unit.call(123)).to eq("ns")
    end

    it "answers microseconds" do
      expect(unit.call(1_000)).to eq("µs")
    end

    it "answers milliseconds" do
      expect(unit.call(1_000_000)).to eq("ms")
    end

    it "answers seconds" do
      expect(unit.call(1_000_000_000)).to eq("s")
    end

    it "answers minutes" do
      expect(unit.call(60_000_000_000)).to eq("m")
    end
  end
end
