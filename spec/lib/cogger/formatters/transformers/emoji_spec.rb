# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Transformers::Emoji do
  subject(:transformer) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers dynamic transform" do
      expect(transformer.call("emoji", "dynamic", "DEBUG")).to eq("🔎")
    end

    it "answers specific transform" do
      expect(transformer.call("emoji", "info", "DEBUG")).to eq("🟢")
    end

    it "answers original target when an emoji" do
      expect(transformer.call("bogus", "dynamic", "DEBUG")).to eq("bogus")
    end

    it "answers original target with unrecognized alias or default" do
      expect(transformer.call("emoji", "bogus", "DEBUG")).to eq("emoji")
    end
  end
end
