# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Property do
  subject(:formatter) { described_class.new }

  describe "#call" do
    include_context "with current time"

    it "answers message with default template" do
      expect(formatter.call(Cogger::Entry.for("test", at: now))).to eq(
        "id=rspec level=INFO at=#{at} message=test\n"
      )
    end

    it "answers message hash with default template" do
      expect(formatter.call(Cogger::Entry.for(at: now, verb: "GET", path: "/"))).to eq(
        "id=rspec level=INFO at=#{at} verb=GET path=/\n"
      )
    end

    it "answers tag with spaces or control characters in quotes" do
      expect(formatter.call(Cogger::Entry.for("a test", control_character: "\t", at: now))).to eq(
        %(id=rspec level=INFO at=#{at} message="a test" control_character="\\t"\n)
      )
    end

    it "answers formatted time tags with default template" do
      expect(formatter.call(Cogger::Entry.for(other: now, at: now))).to eq(
        "id=rspec level=INFO at=#{at} other=#{at}\n"
      )
    end

    it "answers no message with default template" do
      expect(formatter.call(Cogger::Entry.new(at: now))).to eq(
        %(id=rspec level=INFO at=#{at}\n)
      )
    end

    it "answers custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<level>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(at: now, verb: "GET", path: "/"))).to eq(
        %(path=/ verb=GET at=#{at} level=INFO id=rspec\n)
      )
    end

    it "answers custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<level>s"

      expect(formatter.call(Cogger::Entry.for(at: now, verb: "GET", path: "/"))).to eq(
        %(at=#{at} id=rspec level=INFO verb=GET path=/\n)
      )
    end

    it "answers message hash with custom template and invalid keys" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(at: now, verb: "GET", path: "/"))).to eq(
        %(id=rspec level=INFO at=#{at} verb=GET path=/\n)
      )
    end

    it "answers with mixed tags" do
      entry = Cogger::Entry.for at: now,
                                message: "test",
                                path: "/",
                                tags: ["ONE", :TWO, {three: 3, four: 4}]

      expect(formatter.call(entry)).to eq(
        %(id=rspec level=INFO at=#{at} message=test tags="[ONE, TWO]" ) +
        %(three=3 four=4 path=/\n)
      )
    end
  end
end
