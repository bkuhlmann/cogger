# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::JSON do
  subject(:formatter) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }
    let(:at_formatted) { at.utc.strftime "%Y-%m-%dT%H:%M:%S.%L%:z" }

    it "answers default template and message string" do
      expect(formatter.call(Cogger::Entry.for("test", at:))).to eq(
        %(#{{id: "rspec", severity: "INFO", at: at_formatted, message: "test"}.to_json}\n)
      )
    end

    it "answers default template and message hash" do
      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", severity: "INFO", at: at_formatted, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers default template and no message" do
      expect(formatter.call(Cogger::Entry.new(at:))).to eq(
        %(#{{id: "rspec", severity: "INFO", at: at_formatted}.to_json}\n)
      )
    end

    it "answers custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<severity>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{path: "/", verb: "GET", at: at_formatted, severity: "INFO", id: "rspec"}.to_json}\n)
      )
    end

    it "answers custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<severity>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{at: at_formatted, id: "rspec", severity: "INFO", verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers custom template using invalid keys and message hash" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", severity: "INFO", at: at_formatted, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers with mixed tags" do
      entry = Cogger::Entry.for at:,
                                message: "test",
                                path: "/",
                                tags: ["ONE", :TWO, {three: 3, four: 4}]

      proof = {
        id: "rspec",
        severity: "INFO",
        at: at_formatted,
        message: "test",
        tags: %w[ONE TWO],
        three: 3,
        four: 4,
        path: "/"
      }

      expect(formatter.call(entry)).to eq(%(#{proof.to_json}\n))
    end
  end
end
