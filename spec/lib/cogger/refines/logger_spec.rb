# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Refines::Logger do
  using described_class

  subject(:logger) { Logger.new io }

  include_context "with temporary directory"

  describe "#reread" do
    context "with file" do
      let(:io) { temp_dir.join "test.log" }

      it "answers written content" do
        logger.info "This is a test."
        expect(logger.reread).to include("This is a test.")
      end
    end

    context "with string" do
      let(:io) { StringIO.new }

      it "answers written content" do
        logger.info "This is a test."
        expect(logger.reread).to include("This is a test.")
      end
    end

    context "with standard output" do
      let(:io) { $stdout }

      it "answers empty string" do
        logger.info "test"
        expect(logger.reread).to eq("")
      end
    end
  end

  describe "#any" do
    let(:io) { StringIO.new }

    it "logs message with block" do
      logger.any { "Test." }
      expect(logger.reread).to include("ANY -- : Test.")
    end

    it "logs message without block" do
      logger.any "Test."
      expect(logger.reread).to include("ANY -- : Test.")
    end
  end
end
