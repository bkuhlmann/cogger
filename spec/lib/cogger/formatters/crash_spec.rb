# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Crash do
  subject(:formatter) { described_class.new }

  let(:color) { Cogger.color }

  describe "#call" do
    let(:at) { Time.now }

    it "answers string with default template" do
      result = formatter.call "FATAL",
                              at,
                              :test,
                              message: "test",
                              error_message: "Danger!",
                              error_class: KeyError,
                              backtrace: %w[one two three]

      expect(color.decode(result)).to eq(
        [
          [
            "[test] [FATAL] [#{at}] Crash!\n  test\n  Danger! (KeyError)\n  one\n  two\n  three\n",
            :bold,
            :white,
            :on_red
          ],
          ["\n"]
        ]
      )
    end

    context "with custom template" do
      subject(:formatter) { described_class.new template }

      let :template do
        <<~CONTENT
          <red>[%<id>s] [%<severity>s] [%<at>s] Crash!
            %<message>s
            %<error_message>s (%<error_class>s)
          %<backtrace>s</red>
        CONTENT
      end

      it "answers string" do
        result = formatter.call "FATAL",
                                at,
                                :test,
                                message: "test",
                                error_message: "Danger!",
                                error_class: KeyError,
                                backtrace: %w[one two three]

        expect(color.decode(result)).to eq(
          [
            [
              "[test] [FATAL] [#{at}] Crash!\n  test\n  Danger! (KeyError)\n  " \
              "one\n  two\n  three\n",
              :red
            ],
            ["\n"]
          ]
        )
      end
    end
  end
end
