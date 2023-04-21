# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Color do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    let(:at) { Time.now }
    let(:color) { Cogger.color }

    it "answers colorized string with default template and colors" do
      formatter = described_class.new
      result = formatter.call "INFO", at, :test, "test"

      expect(result).to have_color(color, ["test", :green], ["\n"])
    end

    context "when universal and dynamic" do
      let(:template) { "<dynamic>%<severity>s %<at>s %<id>s %<message>s</dynamic>" }

      it "answers colorized string" do
        result = formatter.call "INFO", at, :test, "test"
        expect(result).to have_color(color, ["INFO #{at} test test", :green], ["\n"])
      end
    end

    context "when universal and specific" do
      let(:template) { "<cyan>%<severity>s %<at>s %<id>s %<message>s</cyan>" }

      it "answers colorized string" do
        result = formatter.call "INFO", at, :test, "test"
        expect(result).to have_color(color, ["INFO #{at} test test", :cyan], ["\n"])
      end
    end

    context "when individual and dynamic" do
      let(:template) { "%<severity:dynamic>s %<at:dynamic>s %<id:dynamic>s %<message:dynamic>s" }

      let :proof do
        [
          ["INFO", :green],
          [" "],
          [at.to_s, :green],
          [" "],
          ["test", :green],
          [" "],
          ["test", :green],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call "INFO", at, :test, "test"
        expect(result).to have_color(color, *proof)
      end
    end

    context "when individual and specific" do
      let(:template) { "%<severity:cyan>s %<at:cyan>s %<id:cyan>s %<message:cyan>s" }

      let :proof do
        [
          ["INFO", :cyan],
          [" "],
          [at.to_s, :cyan],
          [" "],
          ["test", :cyan],
          [" "],
          ["test", :cyan],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call "INFO", at, :test, "test"
        expect(result).to have_color(color, *proof)
      end
    end

    context "when individual and mixed (dynamic and specific)" do
      let(:template) { "%<severity:dynamic>s %<at:yellow>s %<id:cyan>s %<message:purple>s" }

      let :proof do
        [
          ["FATAL", :bold, :white, :on_red],
          [" "],
          [at.to_s, :yellow],
          [" "],
          ["test", :cyan],
          [" "],
          ["test", :purple],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call "FATAL", at, :test, "test"
        expect(result).to have_color(color, *proof)
      end
    end

    context "with dynamic emoji template" do
      let(:template) { Cogger.get_formatter(:emoji).last }

      it "answers string without leading space" do
        result = formatter.call "ANY", at, :test, "test"
        expect(result).to have_color(color, ["test", :bold, :white], ["\n"])
      end
    end

    context "with no directives or attributes" do
      let(:template) { "test" }

      it "answers string with no colorization" do
        result = formatter.call "FATAL", at, :test, "test"
        expect(result).to eq("test\n")
      end
    end
  end
end
