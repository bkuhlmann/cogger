# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Kit::Colorizer do
  describe "#call" do
    let(:at) { Time.now }

    it "answers non-dynamic color" do
      expect(described_class.call("green", {severity: "INFO"})).to eq("green")
    end

    it "answers dynamic color based on severity" do
      expect(described_class.call("dynamic", {severity: "INFO"})).to eq("info")
    end
  end
end
