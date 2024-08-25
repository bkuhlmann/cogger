# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Transformers::Color do
  subject(:transformer) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }

    it "answers dynamic transform" do
      expect(transformer.call("test", "dynamic", "DEBUG")).to have_color(color, ["test", :white])
    end

    it "answers specific transform" do
      expect(transformer.call("test", "cyan", "DEBUG")).to have_color(color, ["test", :cyan])
    end

    it "answers original target when an emoji" do
      expect(transformer.call("emoji", "cyan", "DEBUG")).to eq("emoji")
    end

    it "answers original target when not a string" do
      expect(transformer.call(1, "cyan", "DEBUG")).to eq(1)
    end

    it "answers original target with unrecognized alias or default" do
      expect(transformer.call("test", "bogus", "DEBUG")).to eq("test")
    end
  end
end
