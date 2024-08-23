# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Crash do
  subject(:formatter) { described_class.new }

  describe "#call" do
    let(:color) { Cogger.color }
    let(:at) { Time.now }

    let :entry do
      error = KeyError.new("Danger!").tap { |instance| instance.set_backtrace %w[one two three] }
      Cogger::Entry.for_crash "test", error, id: :test
    end

    it "answers string with default template" do
      result = formatter.call entry

      expect(result).to have_color(
        color,
        [
          "[test] [FATAL] [#{at}] Crash!\n  test\n  Danger! (KeyError)\n  one\n  two\n  three",
          :bold,
          :white,
          :on_red
        ],
        ["\n\n"]
      )
    end

    context "with custom template" do
      subject(:formatter) { described_class.new template }

      let :template do
        <<~CONTENT
          <red>[%<id>s] [%<level>s] [%<at>s] Crash!
            %<message>s
            %<error_message>s (%<error_class>s)
          %<backtrace>s</red>
        CONTENT
      end

      it "answers string" do
        result = formatter.call entry

        expect(result).to have_color(
          color,
          [
            "[test] [FATAL] [#{at}] Crash!\n  test\n  Danger! (KeyError)\n  " \
            "one\n  two\n  three",
            :red
          ],
          ["\n\n"]
        )
      end
    end
  end
end
