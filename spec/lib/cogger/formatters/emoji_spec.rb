# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Emoji do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    include_context "with current time"

    let(:color) { Cogger.color }

    it "answers colorized string with default template using emoji and color" do
      formatter = described_class.new
      result = formatter.call Cogger::Entry.for("Test.", at: now)

      expect(result).to have_color(
        color,
        ["🟢 "],
        ["[rspec]", :green],
        [" "],
        ["Test.", :green],
        ["\n"]
      )
    end
  end
end
