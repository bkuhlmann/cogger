# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Entry do
  subject(:entry) { described_class.new }

  describe ".for" do
    let(:bad_encoding) { "b\xE9d".dup.force_encoding "ASCII-8BIT" }

    it "answers entry with defaults" do
      entry = described_class.for

      expect(entry).to have_attributes(
        id: "rspec",
        level: "INFO",
        at: be_a(Time),
        message: nil,
        tags: [],
        datetime_format: Cogger::DATETIME_FORMAT,
        payload: {}
      )
    end

    it "answers entry with uppercase level" do
      entry = described_class.for level: "warn"
      expect(entry).to have_attributes(level: "WARN")
    end

    it "answers entry for string message" do
      entry = described_class.for "test"
      expect(entry).to have_attributes(message: "test")
    end

    it "answers entry for string message with replaced invalid characters" do
      entry = described_class.for bad_encoding
      expect(entry).to have_attributes(message: "b?d")
    end

    it "answers entry for block with string" do
      entry = described_class.for { "test" }
      expect(entry).to have_attributes(message: "test")
    end

    it "answers entry for block with string with replaced invalid characters" do
      entry = described_class.for { bad_encoding }
      expect(entry).to have_attributes(message: "b?d")
    end

    it "answers entry for hash message" do
      entry = described_class.for({one: 1, two: 2})
      expect(entry).to have_attributes(message: nil, payload: {one: 1, two: 2})
    end

    it "answers entry for hash message with replaced invalid characters" do
      entry = described_class.for({message: bad_encoding})
      expect(entry).to have_attributes(message: "b?d")
    end

    it "answers entry for block with hash message with replaced invalid characters" do
      entry = described_class.for { {message: bad_encoding, one: 1, two: 2} }
      expect(entry).to have_attributes(message: "b?d", payload: {one: 1, two: 2})
    end

    it "answers entry with block message precedence" do
      entry = described_class.for("first") { "second" }
      expect(entry).to have_attributes(message: "second")
    end

    it "answers entry for message and payload" do
      entry = described_class.for "test", one: 1, two: 2
      expect(entry).to have_attributes(message: "test", payload: {one: 1, two: 2})
    end

    it "answers entry for message, tags, and payload" do
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

    it "answers entry for message with payload and date/time format" do
      entry = described_class.for "test", datetime_format: "%Y", one: 1, two: 2

      expect(entry).to have_attributes(
        message: "test",
        datetime_format: "%Y",
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
      expect(entry).to have_attributes(id: :test, message: "test")
    end

    it "answers entry with custom level" do
      entry = described_class.for "test", level: "DEBUG"
      expect(entry).to have_attributes(level: "DEBUG")
    end
  end

  describe ".for_crash" do
    it "answers fatal entry" do
      error = StandardError.new "Danger!"
      entry = described_class.for_crash "Crash", error, id: :test

      expect(entry).to have_attributes(
        id: :test,
        level: "FATAL",
        at: kind_of(Time),
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
        level: "INFO",
        at: instance_of(Time),
        tags: [],
        datetime_format: Cogger::DATETIME_FORMAT,
        payload: {}
      )
    end
  end

  describe "#attributes" do
    let(:at) { Time.now }

    it "answers custom attributes" do
      entry = described_class.new at:,
                                  message: "test",
                                  tags: %w[ONE TWO THREE],
                                  payload: {verb: "GET", elapsed: 1.5}

      expect(entry.attributes).to eq(
        id: "rspec",
        level: "INFO",
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
        level: "INFO",
        at:,
        message: "test",
        tags: %w[ONE TWO],
        three: 3,
        four: 4
      )
    end

    it "answers original message when not tagged" do
      entry = described_class.new at:, message: "test"
      expect(entry.tagged_attributes).to eq(id: "rspec", level: "INFO", at:, message: "test")
    end
  end

  describe "#tagged" do
    let(:at) { Time.now }

    it "answers tagged message" do
      entry = described_class.new at:, message: "test", tags: %w[ONE TWO THREE]

      expect(entry.tagged).to eq(
        id: "rspec",
        level: "INFO",
        at:,
        message: "[ONE] [TWO] [THREE] test"
      )
    end

    it "answers original message when not tagged" do
      entry = described_class.new at:, message: "test"
      expect(entry.tagged).to eq(id: "rspec", level: "INFO", at:, message: "test")
    end
  end
end
