# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Configuration do
  subject(:configuration) { described_class.new }

  describe "#initialize" do
    it "answers default configuration" do
      expect(described_class.new).to have_attributes(
        id: "rspec",
        io: $stdout,
        level: Logger::INFO,
        formatter: instance_of(Cogger::Formatters::Emoji),
        tags: [],
        mode: false,
        age: 0,
        size: 1_048_576,
        suffix: "%Y-%m-%d",
        entry: Cogger::Entry,
        logger: Logger
      )
    end

    it "ensures tags are frozen" do
      configuration = described_class.new tags: %w[A B]
      expect(configuration.tags.frozen?).to be(true)
    end
  end

  describe "#entag" do
    it "answers other tag when default tags are empty" do
      expect(configuration.entag("A")).to eq(["A"])
    end

    it "answers other tags when default tags are empty" do
      expect(configuration.entag(%w[A B])).to eq(%w[A B])
    end

    it "doesn't mutate itself with other tags" do
      configuration.entag "A"
      expect(configuration.tags).to eq([])
    end

    it "answers empty tags when there are none" do
      expect(configuration.entag).to eq([])
    end

    it "answers identical object ID without other tags" do
      object_id = configuration.tags.object_id
      configuration.entag

      expect(configuration.tags.object_id).to eq(object_id)
    end
  end

  describe "#to_logger" do
    it "answers logger instance for configuration" do
      expect(configuration.to_logger).to have_attributes(
        progname: "rspec",
        level: Logger::INFO,
        formatter: instance_of(Cogger::Formatters::Emoji)
      )
    end
  end

  describe "#inspect" do
    it "answers attributes" do
      expect(configuration.inspect).to match(
        /
          #<Cogger::Configuration @id=rspec, @io=IO, @level=1,
          @formatter=Cogger::Formatters::Emoji,\s@tags=\[\],\s@mode=false,
          \s@age=0,\s@size=1048576,\s@suffix="%Y-%m-%d",\s@entry=Cogger::Entry,\s@logger=Logger>
        /x
      )
    end
  end
end
