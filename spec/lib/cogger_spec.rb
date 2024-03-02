# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger do
  describe ".loader" do
    it "eager loads" do
      expectation = proc { described_class.loader.eager_load force: true }
      expect(&expectation).not_to raise_error
    end

    it "answers unique tag" do
      expect(described_class.loader.tag).to eq("cogger")
    end
  end

  describe ".new" do
    it "answers hub instance" do
      expect(described_class.new).to be_a(described_class::Hub)
    end
  end
end
