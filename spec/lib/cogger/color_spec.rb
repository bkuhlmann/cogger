# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Color do
  subject(:color) { described_class.new }

  describe "#debug" do
    it "answers default color" do
      expect(color.debug("test")).to eq("\e[37mtest\e[0m")
    end
  end

  describe "#info" do
    it "answers default color" do
      expect(color.info("test")).to eq("\e[32mtest\e[0m")
    end
  end

  describe "#warn" do
    it "answers default color" do
      expect(color.warn("test")).to eq("\e[33mtest\e[0m")
    end
  end

  describe "#error" do
    it "answers default color" do
      expect(color.error("test")).to eq("\e[31mtest\e[0m")
    end
  end

  describe "#fatal" do
    it "answers default color" do
      expect(color.fatal("test")).to eq("\e[37;1;41mtest\e[0m")
    end
  end

  describe "#any" do
    it "answers default color" do
      expect(color.any("test")).to eq("\e[37;1mtest\e[0m")
    end
  end

  context "with missing defaults" do
    subject(:color) { described_class.new defaults: {} }

    it "fails with key error" do
      expectation = proc { color.any "test" }
      expect(&expectation).to raise_error(KeyError, /any/)
    end
  end

  context "with invalid default style" do
    subject(:color) { described_class.new defaults: {debug: %i[bogus]} }

    it "fails with key error" do
      expectation = proc { color.debug "test" }
      expect(&expectation).to raise_error(Pastel::InvalidAttributeNameError, /bad style/i)
    end
  end
end
