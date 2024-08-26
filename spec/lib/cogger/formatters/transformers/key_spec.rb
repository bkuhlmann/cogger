# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Transformers::Key do
  subject(:transformer) { described_class }

  describe "#call" do
    it "answers key when directive is dynamic" do
      expect(transformer.call("dynamic", "INFO")).to eq(:info)
    end

    it "answers key when directive is color (string)" do
      expect(transformer.call("cyan", :info)).to eq(:cyan)
    end

    it "answers key when directive is color (symbol)" do
      expect(transformer.call(:cyan, :info)).to eq(:cyan)
    end
  end
end
