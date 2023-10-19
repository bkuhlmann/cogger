# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Tag do
  subject(:tag) { described_class[singles: ["ONE", :TWO], pairs: {x: 1, y: 2}] }

  describe ".for" do
    it "answers simple singles" do
      expect(described_class.for(1, 2, 3)).to eq(described_class[singles: [1, 2, 3]])
    end

    it "answers evaluated singles" do
      one = proc { "One" }
      two = proc { "Two" }

      expect(described_class.for(one, two)).to eq(described_class[singles: %w[One Two]])
    end

    it "answers pairs" do
      expect(described_class.for({a: 1}, {b: 2}, {c: 3})).to eq(
        described_class[pairs: {a: 1, b: 2, c: 3}]
      )
    end

    it "answers mixed singles and pairs" do
      expect(described_class.for("apple", {a: 1}, proc { "peach" }, {b: 2}, "berry", {c: 3})).to eq(
        described_class[singles: %w[apple peach berry], pairs: {a: 1, b: 2, c: 3}]
      )
    end

    it "answers empty tag when given nothing" do
      expect(described_class.for).to eq(described_class.new)
    end
  end

  describe "#empty?" do
    it "answers true when empty" do
      tag = described_class.new
      expect(tag.empty?).to be(true)
    end

    it "answers false when only singles exist" do
      modification = tag.with pairs: {}
      expect(modification.empty?).to be(false)
    end

    it "answers false when only pairs exist" do
      modification = tag.with singles: []
      expect(modification.empty?).to be(false)
    end

    it "answers false when singles and pairs have elements" do
      expect(tag.empty?).to be(false)
    end
  end

  describe "#to_h" do
    it "answers tags for singles and pairs" do
      expect(tag.to_h).to eq(tags: ["ONE", :TWO], x: 1, y: 2)
    end

    it "answers only pairs" do
      modification = tag.with singles: []
      expect(modification.to_h).to eq(x: 1, y: 2)
    end

    it "answers only singles" do
      modification = tag.with pairs: {}
      expect(modification.to_h).to eq(tags: ["ONE", :TWO])
    end

    it "answers empty hash for empty singles and pairs" do
      tag = described_class.new
      expect(tag.to_h).to eq({})
    end
  end

  describe "#to_s" do
    it "answers tags for singles and pairs" do
      expect(tag.to_s).to eq("[ONE] [TWO] [x=1] [y=2]")
    end

    it "answers only pairs" do
      modification = tag.with singles: []
      expect(modification.to_s).to eq("[x=1] [y=2]")
    end

    it "answers only singles" do
      modification = tag.with pairs: {}
      expect(modification.to_s).to eq("[ONE] [TWO]")
    end

    it "answers empty string for empty singles and pairs" do
      tag = described_class.new
      expect(tag.to_s).to eq("")
    end
  end
end
