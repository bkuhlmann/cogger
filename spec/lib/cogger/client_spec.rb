# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Client do
  subject(:client) { described_class.new Logger.new(StringIO.new), level: :debug }

  let(:color) { Cogger.color }

  describe "#initialize" do
    let(:formatter) { -> _severity, _at, _name, message { "#{message}\n" } }

    it "prints depreation warning" do
      expectation = proc { described_class.new }

      expect(&expectation).to output(
        /Cogger::Client#initialize is deprecated, use `Cogger.new` instead/
      ).to_stderr
    end

    it "yields logger when block is given" do
      client = described_class.new do |logger|
        logger.formatter = formatter
        logger.level = :fatal
        logger.progname = "Test"
      end

      expect(client).to have_attributes(level: Logger::FATAL, formatter:, progname: "Test")
    end

    it "uses attributes when given" do
      client = described_class.new formatter:, level: :fatal, progname: "Test"
      expect(client).to have_attributes(level: Logger::FATAL, formatter:, progname: "Test")
    end
  end

  describe "#formatter" do
    it "answers default formatter" do
      expect(client.formatter).to be_a(Proc)
    end

    it "answers custom formatter" do
      formatter = proc { "test" }
      client = described_class.new { |logger| logger.formatter = formatter }

      expect(client.formatter).to eq(formatter)
    end
  end

  describe "#level" do
    it "answers default level" do
      expect(client.level).to eq(Logger::DEBUG)
    end

    it "answers custom level" do
      client = described_class.new { |logger| logger.level = :warn }
      expect(client.level).to eq(Logger::WARN)
    end
  end

  describe "#progname" do
    it "answers default program name" do
      expect(client.progname).to be(nil)
    end

    it "answers custom program name" do
      client = described_class.new { |logger| logger.progname = "Test" }
      expect(client.progname).to eq("Test")
    end
  end

  describe "#debug" do
    it "answers default color without block" do
      client.debug "test"
      expect(client.reread).to have_color(color, ["test", :white], ["\n"])
    end

    it "answers default color with block" do
      client.debug { "test" }
      expect(client.reread).to have_color(color, ["test", :white], ["\n"])
    end
  end

  describe "#info" do
    it "answers default color without block" do
      client.info "test"
      expect(client.reread).to have_color(color, ["test", :green], ["\n"])
    end

    it "answers default color with block" do
      client.info { "test" }
      expect(client.reread).to have_color(color, ["test", :green], ["\n"])
    end
  end

  describe "#warn" do
    it "answers default color without block" do
      client.warn "test"
      expect(client.reread).to have_color(color, ["test", :yellow], ["\n"])
    end

    it "answers default color with block" do
      client.warn { "test" }
      expect(client.reread).to have_color(color, ["test", :yellow], ["\n"])
    end
  end

  describe "#error" do
    it "answers default color without block" do
      client.error "test"
      expect(client.reread).to have_color(color, ["test", :red], ["\n"])
    end

    it "answers default color with block" do
      client.error { "test" }
      expect(client.reread).to have_color(color, ["test", :red], ["\n"])
    end
  end

  describe "#fatal" do
    it "answers default color without block" do
      client.fatal "test"
      expect(client.reread).to have_color(color, ["test", :bold, :white, :on_red], ["\n"])
    end

    it "answers default color with block" do
      client.fatal { "test" }
      expect(client.reread).to have_color(color, ["test", :bold, :white, :on_red], ["\n"])
    end
  end

  describe "#unknown" do
    it "answers default color without block" do
      client.unknown "test"
      expect(client.reread).to have_color(color, ["test", :dim, :bright_white], ["\n"])
    end

    it "answers default color with block" do
      client.unknown { "test" }
      expect(client.reread).to have_color(color, ["test", :dim, :bright_white], ["\n"])
    end
  end

  describe "#any" do
    it "answers default color without block" do
      client.any "test"
      expect(client.reread).to have_color(color, ["test", :dim, :bright_white], ["\n"])
    end

    it "answers default color with block" do
      client.any { "test" }
      expect(client.reread).to have_color(color, ["test", :dim, :bright_white], ["\n"])
    end
  end

  describe "#reread" do
    it "answers what was previously written" do
      client.info "This is a test."
      expect(client.reread).to include("This is a test.")
    end
  end
end
