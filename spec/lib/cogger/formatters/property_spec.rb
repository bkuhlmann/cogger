# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Property do
  subject(:formatter) { described_class.new }

  describe "#call" do
    include_context "with static time"

    it "answers message with default template" do
      expect(formatter.call(Cogger::Entry.for("test", at:))).to eq(
        "id=rspec level=INFO at=#{at_format} message=test\n"
      )
    end

    it "answers message hash with default template" do
      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        "id=rspec level=INFO at=#{at_format} verb=GET path=/\n"
      )
    end

    it "answers tag with spaces or control characters in quotes" do
      expect(formatter.call(Cogger::Entry.for("a test", control_character: "\t", at:))).to eq(
        %(id=rspec level=INFO at=#{at_format} message="a test" control_character="\\t"\n)
      )
    end

    it "answers formatted time tags with default template" do
      other = Time.new 2000, 1, 1, 0, 0, 0, "+00:00"
      expect(formatter.call(Cogger::Entry.for(other:, at:))).to eq(
        "id=rspec level=INFO at=#{at_format} other=2000-01-01T00:00:00.000+00:00\n"
      )
    end

    it "answers no message with default template" do
      expect(formatter.call(Cogger::Entry.new(at:))).to eq(
        %(id=rspec level=INFO at=#{at_format}\n)
      )
    end

    it "answers custom template and ordered message hash" do
      formatter = described_class.new "%<path>s %<verb>s %<at>s %<level>s %<id>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(path=/ verb=GET at=#{at_format} level=INFO id=rspec\n)
      )
    end

    it "answers custom template and ordered metadata only" do
      formatter = described_class.new "%<at>s %<id>s %<level>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(at=#{at_format} id=rspec level=INFO verb=GET path=/\n)
      )
    end

    it "answers message hash with custom template and invalid keys" do
      formatter = described_class.new "%<one>s %<two>s %<three>s"

      expect(formatter.call(Cogger::Entry.for(at:, verb: "GET", path: "/"))).to eq(
        %(id=rspec level=INFO at=#{at_format} verb=GET path=/\n)
      )
    end

    it "answers with mixed tags" do
      entry = Cogger::Entry.for at:,
                                message: "test",
                                path: "/",
                                tags: ["ONE", :TWO, {three: 3, four: 4}]

      expect(formatter.call(entry)).to eq(
        %(id=rspec level=INFO at=#{at_format} message=test tags="[ONE, TWO]" ) +
        %(three=3 four=4 path=/\n)
      )
    end
  end
end
