# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Emoji do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    let(:at) { Time.now }
    let(:color) { Cogger.color }

    it "answers colorized string with default template using emoji and color" do
      formatter = described_class.new
      result = formatter.call Cogger::Entry.for("test", id: :test)

      expect(result).to have_color(color, ["🟢 "], ["test", :green], ["\n"])
    end
  end
end
