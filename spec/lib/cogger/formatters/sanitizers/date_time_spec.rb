# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Sanitizers::DateTime do
  subject(:sanitizer) { described_class }

  describe "#call" do
    it "answer sanitized time" do
      expect(sanitizer.call(Time.utc(2000, 1, 2, 3, 4, 5))).to eq("2000-01-02T03:04:05.000+00:00")
    end

    it "answer sanitized date" do
      expect(sanitizer.call(Date.new(2000, 1, 2))).to eq("2000-01-02T00:00:00.000+00:00")
    end

    it "answer sanitized date/time" do
      expect(sanitizer.call(DateTime.new(2000, 1, 2, 3, 4, 5))).to eq(
        "2000-01-02T03:04:05.000+00:00"
      )
    end

    it "answers original value with nothing to sanitize" do
      expect(sanitizer.call(:test)).to eq(:test)
    end

    it "answers custom date/time format" do
      expect(sanitizer.call(Date.new(2000, 1, 2), format: "%Y")).to eq("2000")
    end

    it "answers nil when nil" do
      expect(sanitizer.call(nil)).to be(nil)
    end
  end
end
