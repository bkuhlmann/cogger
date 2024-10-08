# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::JSON do
  subject(:formatter) { described_class.new }

  describe "#call" do
    include_context "with static time"

    it "answers message string with default template" do
      expect(formatter.call(Cogger::Entry.for("test", at:))).to eq(
        %(#{{id: "rspec", level: "INFO", at: at_format, message: "test"}.to_json}\n)
      )
    end

    it "answers message hash with default template" do
      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", level: "INFO", at: at_format, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers mixed tags with default template" do
      entry = Cogger::Entry.for at:,
                                message: "test",
                                path: "/",
                                tags: ["ONE", :TWO, {three: 3, four: 4}]

      proof = {
        id: "rspec",
        level: "INFO",
        at: at_format,
        message: "test",
        tags: %w[ONE TWO],
        three: 3,
        four: 4,
        path: "/"
      }

      expect(formatter.call(entry)).to eq(%(#{proof.to_json}\n))
    end

    it "answers no message with default template" do
      expect(formatter.call(Cogger::Entry.for(at:))).to eq(
        %(#{{id: "rspec", level: "INFO", at: at_format}.to_json}\n)
      )
    end

    it "answers ordered message hash with custom template" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<level>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{path: "/", verb: "GET", at: at_format, level: "INFO", id: "rspec"}.to_json}\n)
      )
    end

    it "answers ordered metadata only with custom template" do
      formatter = described_class.new "%<at>s %<id>s %<level>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{at: at_format, id: "rspec", level: "INFO", verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers message hash with custom template and non-matching keys" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", level: "INFO", at: at_format, verb: "GET", path: "/"}.to_json}\n)
      )
    end
  end
end
