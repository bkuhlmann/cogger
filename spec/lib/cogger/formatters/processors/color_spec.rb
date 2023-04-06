# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Processors::Color do
  subject(:processor) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }
    let(:colorer) { Cogger.colorer }

    it "answers transformed template and colorized message" do
      result = processor.call "%<emoji:dynamic>s %<message:dynamic>s", "INFO", at, :test, "test"

      expect(result).to eq(
        [
          "%<emoji>s %<message>s",
          {at:, id: :test, emoji: "🟢", message: "\e[32mtest\e[0m", severity: "INFO"}
        ]
      )
    end

    it "answers colorized template and attributes when universal and dynamic" do
      result = processor.call "<dynamic>%<severity>s %<at>s %<id>s %<message>s</dynamic>",
                              "INFO",
                              at,
                              :test,
                              "test"

      expect(result).to eq(
        [
          "\e[32m%<severity>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: :test, message: "test", severity: "INFO"}
        ]
      )
    end

    it "answers colorized template and attributes when universal and specific" do
      result = processor.call "<cyan>%<severity>s %<at>s %<id>s %<message>s</cyan>",
                              "INFO",
                              at,
                              :test,
                              "test"

      expect(result).to eq(
        [
          "\e[36m%<severity>s %<at>s %<id>s %<message>s\e[0m",
          {at:, id: :test, message: "test", severity: "INFO"}

        ]
      )
    end

    it "answers transformed template and colorized attributes when individual and dynamic" do
      result = processor.call "%<severity:dynamic>s %<at:dynamic>s %<id:dynamic>s " \
                              "%<message:dynamic>s",
                              "INFO",
                              at,
                              :test,
                              "test"

      expect(result).to eq(
        [
          "%<severity>s %<at>s %<id>s %<message>s",
          {
            at: "\e[32m#{at}\e[0m",
            id: "\e[32mtest\e[0m",
            message: "\e[32mtest\e[0m",
            severity: "\e[32mINFO\e[0m"
          }
        ]
      )
    end

    it "answers transformed template and colorized attributes when individual and specific" do
      result = processor.call "%<severity:cyan>s %<at:cyan>s %<id:cyan>s %<message:cyan>s",
                              "INFO",
                              at,
                              :test,
                              "test"

      expect(result).to eq(
        [
          "%<severity>s %<at>s %<id>s %<message>s",
          {
            at: "\e[36m#{at}\e[0m",
            id: "\e[36mtest\e[0m",
            message: "\e[36mtest\e[0m",
            severity: "\e[36mINFO\e[0m"
          }
        ]
      )
    end

    it "answers transformed template and colorized attributes when individually mixed" do
      result = processor.call "%<severity:dynamic>s %<at:yellow>s %<id:cyan>s %<message:purple>s",
                              "INFO",
                              at,
                              :test,
                              "test"

      expect(result).to eq(
        [
          "%<severity>s %<at>s %<id>s %<message>s",
          {
            at: "\e[33m#{at}\e[0m",
            id: "\e[36mtest\e[0m",
            message: "\e[35mtest\e[0m",
            severity: "\e[32mINFO\e[0m"
          }
        ]
      )
    end

    it "answers original template and empty attributes with no directives or attributes" do
      result = processor.call "test", "FATAL", at, :test, "test"
      expect(result).to eq(["test", {}])
    end
  end
end
