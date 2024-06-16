# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Kit::Colorizer do
  describe "#call" do
    let(:at) { Time.now }

    it "answers non-dynamic color" do
      expect(described_class.call("green", {level: "INFO"})).to eq("green")
    end

    it "answers dynamic color based on level" do
      expect(described_class.call("dynamic", {level: "INFO"})).to eq("info")
    end
  end
end
