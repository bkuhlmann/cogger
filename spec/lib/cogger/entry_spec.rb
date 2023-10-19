# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Entry do
  subject(:entry) { described_class.new }

  describe ".for" do
    it "answers entry with defaults" do
      entry = described_class.for

      expect(entry).to have_attributes(
        id: "rspec",
        severity: "INFO",
        message: nil,
        tags: [],
        payload: {}
      )
    end

    it "answers entry with uppercase severity" do
      entry = described_class.for severity: "warn"
      expect(entry).to have_attributes(severity: "WARN")
    end

    it "answers entry for message with string" do
      entry = described_class.for "test"
      expect(entry).to have_attributes(message: "test", tags: [])
    end

    it "answers entry for message with hash" do
      entry = described_class.for({one: 1, two: 2})
      expect(entry).to have_attributes(message: {one: 1, two: 2}, tags: [])
    end

    it "answers entry for block with string" do
      entry = described_class.for { "test" }
      expect(entry).to have_attributes(message: "test", tags: [])
    end

    it "answers entry for block with hash" do
      entry = described_class.for { {one: 1, two: 2} }
      expect(entry).to have_attributes(message: {one: 1, two: 2}, tags: [])
    end

    it "answers entry with block precedence for message and block" do
      entry = described_class.for("first") { "second" }
      expect(entry).to have_attributes(message: "second", tags: [])
    end

    it "answers entry for message and payload" do
      entry = described_class.for "test", one: 1, two: 2
      expect(entry).to have_attributes(message: "test", tags: [], payload: {one: 1, two: 2})
    end

    it "answers entry for message and payload with tags" do
      entry = described_class.for "test", tags: %w[ONE TWO THREE], one: 1, two: 2

      expect(entry).to have_attributes(
        message: "test",
        tags: %w[ONE TWO THREE],
        payload: {one: 1, two: 2}
      )
    end

    it "answers entry for block with payload and tags" do
      entry = described_class.for(tags: %w[ONE TWO THREE], one: 1, two: 2) { "test" }

      expect(entry).to have_attributes(
        message: "test",
        tags: %w[ONE TWO THREE],
        payload: {one: 1, two: 2}
      )
    end

    it "answers entry for non-string message" do
      object = Object.new
      entry = described_class.for object

      expect(entry).to have_attributes(message: object, tags: [], payload: {})
    end

    it "answers entry with custom ID" do
      entry = described_class.for "test", id: :test
      expect(entry).to have_attributes(id: :test, message: "test", payload: {})
    end

    it "answers entry with custom severity" do
      entry = described_class.for "test", severity: "DEBUG"
      expect(entry).to have_attributes(severity: "DEBUG", message: "test", payload: {})
    end
  end

  describe ".for_crash" do
    it "answers fatal entry" do
      error = StandardError.new "Danger!"
      entry = described_class.for_crash "Crash", error, id: :test

      expect(entry).to have_attributes(
        id: :test,
        severity: "FATAL",
        message: "Crash",
        payload: {
          error_message: "Danger!",
          error_class: StandardError,
          backtrace: nil
        }
      )
    end
  end

  describe "#initialize" do
    it "answers defaults" do
      expect(entry).to have_attributes(
        id: "rspec",
        severity: "INFO",
        at: instance_of(Time),
        tags: [],
        payload: {}
      )
    end
  end

  describe "#attributes" do
    it "answers custom attributes" do
      at = Time.now
      entry = described_class.new at:,
                                  message: "test",
                                  tags: %w[ONE TWO THREE],
                                  payload: {verb: "GET", elapsed: 1.5}

      expect(entry.attributes).to eq(
        id: "rspec",
        severity: "INFO",
        at:,
        message: "test",
        verb: "GET",
        elapsed: 1.5
      )
    end
  end

  describe "#tagged_attributes" do
    let(:at) { Time.now }

    it "answers tagged message" do
      entry = described_class.new at:, message: "test", tags: ["ONE", "TWO", {three: 3, four: 4}]

      expect(entry.tagged_attributes).to eq(
        id: "rspec",
        severity: "INFO",
        at:,
        message: "test",
        tags: %w[ONE TWO],
        three: 3,
        four: 4
      )
    end

    it "answers original message when not tagged" do
      entry = described_class.new at:, message: "test"

      expect(entry.tagged_attributes).to eq(id: "rspec", severity: "INFO", at:, message: "test")
    end
  end

  describe "#tagged" do
    let(:at) { Time.now }

    it "answers tagged message" do
      entry = described_class.new at:, message: "test", tags: %w[ONE TWO THREE]

      expect(entry.tagged).to eq(
        id: "rspec",
        severity: "INFO",
        at:,
        message: "[ONE] [TWO] [THREE] test"
      )
    end

    it "answers original message when not tagged" do
      entry = described_class.new at:, message: "test"

      expect(entry.tagged).to eq(id: "rspec", severity: "INFO", at:, message: "test")
    end
  end
end
