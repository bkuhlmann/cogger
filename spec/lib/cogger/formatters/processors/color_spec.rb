# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Processors::Color do
  subject(:processor) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }
    let(:colorer) { Cogger.colorer }
    let(:entry) { Cogger::Entry[at:, message: "test"] }

    it "answers template and attributes for emoji" do
      result = processor.call "%<emoji:dynamic>s %<message:dynamic>s", entry

      expect(result).to eq(
        [
          "%<emoji>s %<message>s",
          {at:, id: "rspec", emoji: "🟢", message: "\e[32mtest\e[0m", level: "INFO"}
        ]
      )
    end

    it "answers template and attributes when universal and dynamic" do
      result = processor.call "<dynamic>%<level>s %<at>s %<id>s %<message>s</dynamic>", entry

      expect(result).to eq(
        [
          "\e[32m%<level>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: "rspec", message: "test", level: "INFO"}
        ]
      )
    end

    it "answers template and attributes when universal and specific" do
      result = processor.call "<cyan>%<level>s %<at>s %<id>s %<message>s</cyan>", entry

      expect(result).to eq(
        [
          "\e[36m%<level>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: "rspec", message: "test", level: "INFO"}

        ]
      )
    end

    it "answers template and attributes when individual and dynamic" do
      result = processor.call "%<level:dynamic>s %<at:dynamic>s %<id:dynamic>s " \
                              "%<message:dynamic>s",
                              entry

      expect(result).to eq(
        [
          "%<level>s %<at>s %<id>s %<message>s",
          {
            at: "\e[32m#{at}\e[0m",
            id: "\e[32mrspec\e[0m",
            message: "\e[32mtest\e[0m",
            level: "\e[32mINFO\e[0m"
          }
        ]
      )
    end

    it "answers template and attributes when individual and specific" do
      result = processor.call "%<level:cyan>s %<at:cyan>s %<id:cyan>s %<message:cyan>s", entry

      expect(result).to eq(
        [
          "%<level>s %<at>s %<id>s %<message>s",
          {
            at: "\e[36m#{at}\e[0m",
            id: "\e[36mrspec\e[0m",
            message: "\e[36mtest\e[0m",
            level: "\e[36mINFO\e[0m"
          }
        ]
      )
    end

    it "answers template and attributes when individually mixed" do
      result = processor.call "%<level:dynamic>s %<at:yellow>s %<id:cyan>s %<message:purple>s",
                              entry

      expect(result).to eq(
        [
          "%<level>s %<at>s %<id>s %<message>s",
          {
            at: "\e[33m#{at}\e[0m",
            id: "\e[36mrspec\e[0m",
            message: "\e[35mtest\e[0m",
            level: "\e[32mINFO\e[0m"
          }
        ]
      )
    end

    it "answers original template and attributes" do
      result = processor.call "test", entry
      expect(result).to eq(["test", {at:, id: "rspec", message: "test", level: "INFO"}])
    end
  end
end
