# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Hub do
  using Refinements::StringIO

  subject(:logger) { described_class.new io:, level: Logger::DEBUG }

  let(:io) { StringIO.new }
  let(:color) { Cogger.color }

  describe "#initialize" do
    it "answers logger with default formatter" do
      logger = described_class.new
      expect(logger.inspect).to include(Cogger::Formatters::Emoji.to_s)
    end

    it "answers logger with formatter found by symbol using default template" do
      logger = described_class.new formatter: :json
      expect(logger.inspect).to include(Cogger::Formatters::JSON.to_s)
    end

    it "answers logger with formatter found by symbol using custom template" do
      logger = described_class.new formatter: :detail
      expect(logger.inspect).to include(Cogger::Formatters::Simple.to_s)
    end

    it "answers logger with formatter found by string using default template" do
      logger = described_class.new formatter: "json"
      expect(logger.inspect).to include(Cogger::Formatters::JSON.to_s)
    end

    it "answers logger with specific formatter" do
      logger = described_class.new formatter: Cogger::Formatters::JSON.new
      expect(logger.inspect).to include(Cogger::Formatters::JSON.to_s)
    end
  end

  describe "#add_stream" do
    it "answers itself" do
      expect(logger.add_stream(io: StringIO.new)).to be_a(described_class)
    end
  end

  shared_examples "a log" do |message|
    it "answers true without block" do
      expect(logger.public_send(message, "test")).to be(true)
    end

    it "answers true with block" do
      block = proc { "test" }
      result = logger.public_send message, &block

      expect(result).to be(true)
    end

    it "crashes with standard error" do
      logger = described_class.new formatter: Cogger::Formatters::Simple.new(Object.new)
      expectation = proc { logger.info }
      expect(&expectation).to output(/FATAL.+Crash/).to_stdout
    end
  end

  describe "#debug" do
    it "logs entry with block" do
      logger.debug { "test" }
      expect(io.reread).to have_color(color, ["🔎 "], ["test", :white], ["\n"])
    end

    it "logs entry without block" do
      logger.debug "test"
      expect(io.reread).to have_color(color, ["🔎 "], ["test", :white], ["\n"])
    end

    it_behaves_like "a log", :debug
  end

  describe "#info" do
    it "logs entry with block" do
      logger.info { "test" }
      expect(io.reread).to have_color(color, ["🟢 "], ["test", :green], ["\n"])
    end

    it "logs entry without block" do
      logger.info "test"
      expect(io.reread).to have_color(color, ["🟢 "], ["test", :green], ["\n"])
    end

    it_behaves_like "a log", :info
  end

  describe "#warn" do
    it "logs entry with block" do
      logger.warn { "test" }
      expect(io.reread).to have_color(color, ["⚠️  "], ["test", :yellow], ["\n"])
    end

    it "logs entry without block" do
      logger.warn "test"
      expect(io.reread).to have_color(color, ["⚠️  "], ["test", :yellow], ["\n"])
    end

    it_behaves_like "a log", :warn
  end

  describe "#error" do
    it "logs entry with block" do
      logger.error { "test" }
      expect(io.reread).to have_color(color, ["🛑 "], ["test", :red], ["\n"])
    end

    it "logs entry without block" do
      logger.error "test"
      expect(io.reread).to have_color(color, ["🛑 "], ["test", :red], ["\n"])
    end

    it_behaves_like "a log", :error
  end

  describe "#fatal" do
    it "logs entry with block" do
      logger.fatal { "test" }
      expect(io.reread).to have_color(color, ["🔥 "], ["test", :bold, :white, :on_red], ["\n"])
    end

    it "logs entry without block" do
      logger.fatal "test"
      expect(io.reread).to have_color(color, ["🔥 "], ["test", :bold, :white, :on_red], ["\n"])
    end

    it_behaves_like "a log", :fatal
  end

  describe "#unknown" do
    it "logs entry with block" do
      logger.unknown { "test" }
      expect(io.reread).to have_color(color, ["⚫️ "], ["test", :dim, :bright_white], ["\n"])
    end

    it "logs entry without block" do
      logger.unknown "test"
      expect(io.reread).to have_color(color, ["⚫️ "], ["test", :dim, :bright_white], ["\n"])
    end

    it_behaves_like "a log", :unknown
  end

  describe "#any" do
    it "logs entry with block" do
      logger.any { "test" }
      expect(io.reread).to have_color(color, ["⚫️ "], ["test", :dim, :bright_white], ["\n"])
    end

    it "logs entry without block" do
      logger.any "test"
      expect(io.reread).to have_color(color, ["⚫️ "], ["test", :dim, :bright_white], ["\n"])
    end

    it_behaves_like "a log", :any
  end

  describe "#add" do
    it "adds entry with block" do
      logger.add(Logger::INFO) { "test" }
      expect(io.reread).to have_color(color, ["🟢 "], ["test", :green], ["\n"])
    end

    it "adds entry without block" do
      logger.add Logger::INFO, "test"
      expect(io.reread).to have_color(color, ["🟢 "], ["test", :green], ["\n"])
    end

    it "adds any entry with invalid severity" do
      logger.add 13, "test"
      expect(io.reread).to have_color(color, ["⚫️ "], ["test", :dim, :bright_white], ["\n"])
    end
  end

  describe "#abort" do
    it "aborts with no message" do
      logger.abort
    rescue SystemExit
      expect(io.reread).to eq("")
    end

    it "logs error with payload" do
      logger.abort message: "Danger!"
    rescue SystemExit
      expect(io.reread).to have_color(color, ["🛑 "], ["Danger!", :red], ["\n"])
    end

    it "logs error with message" do
      logger.abort "test"
    rescue SystemExit
      expect(io.reread).to have_color(color, ["🛑 "], ["test", :red], ["\n"])
    end

    it "aborts with exit status 1" do
      logger.abort { "test" }
    rescue SystemExit => error
      expect(error).to have_attributes(message: "exit", status: 1)
    end
  end

  describe "#reread" do
    it "answers what was previously written" do
      logger.info "This is a test."
      expect(logger.reread).to include("This is a test.")
    end
  end

  describe "#inspect" do
    it "answers class name configuration attributes prefix" do
      expect(logger.inspect).to include("#<Cogger::Hub @id=rspec")
    end

    it "answers double shovel suffix" do
      expect(logger.inspect).to end_with(">")
    end
  end
end
