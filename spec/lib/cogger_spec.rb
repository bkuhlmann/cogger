# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger do
  describe ".init" do
    it "answers depreciation warning" do
      expectation = proc { described_class.init }
      expect(&expectation).to output(/Cogger#init is deprecated, use `.new` instead./).to_stderr
    end

    it "answers client with default configuration" do
      client = described_class.init

      expect(client).to have_attributes(
        level: Logger::INFO,
        formatter: kind_of(Proc),
        progname: nil
      )
    end

    it "answers client with custom configuration" do
      formatter = -> _severity, _at, _name, message { "#{message}\n" }
      client = described_class.init formatter:, level: :debug, progname: "Test"

      expect(client).to have_attributes(level: Logger::DEBUG, formatter:, progname: "Test")
    end

    it "yields to instance when block is given" do
      client = described_class.init do |logger|
        logger.level = :fatal
        logger.progname = "Test"
      end

      expect(client).to have_attributes(
        level: Logger::FATAL,
        formatter: kind_of(Proc),
        progname: "Test"
      )
    end

    it "answers client instance" do
      expect(described_class.init).to be_a(Cogger::Client)
    end
  end

  describe ".new" do
    it "answers hub instance" do
      expect(described_class.new).to be_a(Cogger::Hub)
    end
  end
end
