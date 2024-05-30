# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Logfmt do
  subject(:formatter) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }
    let(:at_formatted) { at.utc.strftime "%Y-%m-%dT%H:%M:%S.%L%:z" }

    it "answers default template and message string" do
      expect(formatter.call(Cogger::Entry.for("test", at:))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted} message=test\n)
      )
    end

    it "wraps tag values with spaces or control characters in quotes" do
      expect(formatter.call(Cogger::Entry.for("test message", control_character: "\t", at:))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted} message="test message" control_character="\\t"\n)
      )
    end

    it "formats Time tag values" do
      expect(formatter.call(Cogger::Entry.for(another_time: at, at:))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted} another_time=#{at_formatted}\n)
      )
    end

    it "answers default template and message hash" do
      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted} verb=GET path=/\n)
      )
    end

    it "answers default template and no message" do
      expect(formatter.call(Cogger::Entry.new(at:))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted}\n)
      )
    end

    it "answers custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<severity>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(path=/ verb=GET at=#{at_formatted} severity=INFO id=rspec\n)
      )
    end

    it "answers custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<severity>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(at=#{at_formatted} id=rspec severity=INFO verb=GET path=/\n)
      )
    end

    it "answers custom template using invalid keys and message hash" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(id=rspec severity=INFO at=#{at_formatted} verb=GET path=/\n)
      )
    end

    it "answers with mixed tags" do
      entry = Cogger::Entry.for at:,
                                message: "test",
                                path: "/",
                                tags: ["ONE", :TWO, {three: 3, four: 4}]

      proof = %W[
        id=rspec
        severity=INFO
        at=#{at_formatted}
        message=test
        tags="[ONE, TWO]"
        three=3
        four=4
        path=/
      ].join(" ")

      expect(formatter.call(entry)).to eq(%(#{proof}\n))
    end
  end
end
