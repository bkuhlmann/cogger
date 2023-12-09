# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Time::Clock do
  subject(:clock) { described_class }

  describe "#call" do
    it "answers current time in realtime" do
      expect(clock.call(Process::CLOCK_REALTIME)).to be_a(Integer)
    end

    it "answers current time in nanoseconds (default)" do
      expect(clock.call).to be_a(Integer)
    end

    it "answers current time in seconds (custom)" do
      expect(clock.call(unit: :second)).to be_a(Integer)
    end
  end
end
