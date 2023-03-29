# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Program do
  describe ".call" do
    it "answers default program name" do
      expect(described_class.call).to eq("rspec")
    end

    it "answers custom program name" do
      expect(described_class.call("test")).to eq("test")
    end

    it "answers custom program name without extension" do
      expect(described_class.call("test.rb")).to eq("test")
    end
  end
end
