# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::JSON do
  subject(:formatter) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }

    it "answers default template and message string" do
      expect(formatter.call(Cogger::Entry.for("test"))).to eq(
        %(#{{id: "rspec", severity: "INFO", at:, message: "test"}.to_json}\n)
      )
    end

    it "answers default template and message hash" do
      expect(formatter.call(Cogger::Entry.for(verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", severity: "INFO", at:, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers default template and no message" do
      expect(formatter.call(Cogger::Entry.new)).to eq(
        %(#{{id: "rspec", severity: "INFO", at:}.to_json}\n)
      )
    end

    it "answers custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<severity>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(verb: "GET", path: "/"))).to eq(
        %(#{{path: "/", verb: "GET", at:, severity: "INFO", id: "rspec"}.to_json}\n)
      )
    end

    it "answers custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<severity>s"

      expect(formatter.call(Cogger::Entry.for(verb: "GET", path: "/"))).to eq(
        %(#{{at:, id: "rspec", severity: "INFO", verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers custom template using invalid keys and message hash" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(verb: "GET", path: "/"))).to eq(
        %(#{{id: "rspec", severity: "INFO", at:, verb: "GET", path: "/"}.to_json}\n)
      )
    end

    it "answers with mixed tags" do
      entry = Cogger::Entry.for message: "test", path: "/", tags: ["ONE", :TWO, {three: 3, four: 4}]

      proof = {
        id: "rspec",
        severity: "INFO",
        at:,
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
