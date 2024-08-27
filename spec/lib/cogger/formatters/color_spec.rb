# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Color do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    include_context "with current time"

    let(:color) { Cogger.color }
    let(:entry) { Cogger::Entry[at: now, message: "Test."] }

    it "answers colorized string with default template and colors" do
      formatter = described_class.new
      result = formatter.call entry

      expect(result).to have_color(
        color,
        ["[rspec]", :green],
        [" "],
        ["Test.", :green],
        ["\n"]
      )
    end

    context "with dynamic element" do
      let(:template) { "<dynamic>%<level>s %<at>s %<id>s %<message>s</dynamic>" }

      it "answers colorized string" do
        result = formatter.call entry
        expect(result).to have_color(color, ["INFO #{at} rspec Test.", :green], ["\n"])
      end
    end

    context "with specific element" do
      let(:template) { "<cyan>%<level>s %<at>s %<id>s %<message>s</cyan>" }

      it "answers colorized string" do
        result = formatter.call entry
        expect(result).to have_color(color, ["INFO #{at} rspec Test.", :cyan], ["\n"])
      end
    end

    context "with dynamic keys" do
      let(:template) { "%<level:dynamic>s %<at:dynamic>s %<id:dynamic>s %<message:dynamic>s" }

      let :proof do
        [
          ["INFO", :green],
          [" "],
          [at.to_s, :green],
          [" "],
          ["rspec", :green],
          [" "],
          ["Test.", :green],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call entry
        expect(result).to have_color(color, *proof)
      end
    end

    context "when specific keys" do
      let(:template) { "%<level:cyan>s %<at:cyan>s %<id:cyan>s %<message:cyan>s" }

      let :proof do
        [
          ["INFO", :cyan],
          [" "],
          [at.to_s, :cyan],
          [" "],
          ["rspec", :cyan],
          [" "],
          ["Test.", :cyan],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call entry
        expect(result).to have_color(color, *proof)
      end
    end

    context "with dynamic and specific keys" do
      let(:template) { "%<level:dynamic>s %<at:yellow>s %<id:cyan>s %<message:purple>s" }

      let :proof do
        [
          ["FATAL", :bold, :white, :on_red],
          [" "],
          [at.to_s, :yellow],
          [" "],
          ["rspec", :cyan],
          [" "],
          ["Test.", :purple],
          ["\n"]
        ]
      end

      it "answers colorized string" do
        result = formatter.call Cogger::Entry[level: "FATAL", at: now, message: "Test."]
        expect(result).to have_color(color, *proof)
      end
    end

    context "with dynamic emoji" do
      let(:template) { Cogger::Formatters::Emoji::TEMPLATE }

      it "answers colorized string" do
        result = formatter.call Cogger::Entry[level: "ANY", at: now, message: "Test."]

        expect(result).to have_color(
          color,
          ["⚫️ "],
          ["[rspec]", :dim, :bright_white],
          [" "],
          ["Test.", :dim, :bright_white],
          ["\n"]
        )
      end
    end

    context "with specific emoji" do
      let(:template) { "%<emoji:any>s %<id:dynamic>s" }

      it "answers string without leading space" do
        result = formatter.call Cogger::Entry[level: "INFO", at: now, message: "Test."]

        expect(result).to have_color(
          color,
          ["⚫️ "],
          ["rspec", :green],
          ["\n"]
        )
      end
    end

    context "with no directives" do
      let(:template) { "test" }

      it "answers string with no colorization" do
        result = formatter.call "FATAL", at, :test, entry
        expect(result).to eq("test\n")
      end
    end
  end
end
