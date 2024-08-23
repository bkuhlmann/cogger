# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Processors::Color do
  subject(:processor) { described_class.new }

  describe "#call" do
    let(:entry) { Cogger::Entry[at:, message: "test"] }
    let(:at) { Time.now }

    it "answers template and attributes for dynamic emoji and message" do
      result = processor.call "%<emoji:dynamic>s %<message:dynamic>s", entry

      expect(result).to eq(
        [
          "🟢 \e[32m%<message>s\e[0m",
          {at:, id: "rspec", message: "test", level: "INFO"}
        ]
      )
    end

    it "answers template and attributes for dynamic template" do
      result = processor.call "<dynamic>%<level>s %<at>s %<id>s %<message>s</dynamic>", entry

      expect(result).to eq(
        [
          "\e[32m%<level>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: "rspec", message: "test", level: "INFO"}
        ]
      )
    end

    it "answers template and attributes for specific template" do
      result = processor.call "<cyan>%<level>s %<at>s %<id>s %<message>s</cyan>", entry

      expect(result).to eq(
        [
          "\e[36m%<level>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: "rspec", message: "test", level: "INFO"}

        ]
      )
    end

    it "answers template and attributes dynamic keys" do
      result = processor.call "%<level:dynamic>s %<at:dynamic>s %<id:dynamic>s " \
                              "%<message:dynamic>s",
                              entry

      expect(result).to eq(
        [
          "\e[32m%<level>s\e[0m \e[32m%<at>s\e[0m \e[32m%<id>s\e[0m \e[32m%<message>s\e[0m",
          {
            at:,
            id: "rspec",
            message: "test",
            level: "INFO"
          }
        ]
      )
    end

    it "answers template and attributes for specific keys" do
      result = processor.call "%<level:cyan>s %<at:cyan>s %<id:cyan>s %<message:cyan>s", entry

      expect(result).to eq(
        [
          "\e[36m%<level>s\e[0m \e[36m%<at>s\e[0m \e[36m%<id>s\e[0m \e[36m%<message>s\e[0m",
          {
            at:,
            id: "rspec",
            message: "test",
            level: "INFO"
          }
        ]
      )
    end

    it "answers template and attributes for mixed dynamic/specific keys" do
      result = processor.call "%<level:dynamic>s %<at:yellow>s %<id:cyan>s %<message:purple>s",
                              entry

      expect(result).to eq(
        [
          "\e[32m%<level>s\e[0m \e[33m%<at>s\e[0m \e[36m%<id>s\e[0m \e[35m%<message>s\e[0m",
          {
            at:,
            id: "rspec",
            message: "test",
            level: "INFO"
          }
        ]
      )
    end

    it "answers original template and attributes for plain template" do
      result = processor.call "test", entry
      expect(result).to eq(["test", {at:, id: "rspec", message: "test", level: "INFO"}])
    end
  end
end
