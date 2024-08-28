# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Sanitizers::Escape do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    it "answers integer as string" do
      expect(sanitizer.call(1)).to eq("1")
    end

    it "answers string as string" do
      expect(sanitizer.call("test")).to eq("test")
    end

    it "answers symbol as string" do
      expect(sanitizer.call(:test)).to eq("test")
    end

    it "answers string with spaces as quoted string" do
      expect(sanitizer.call("one two")).to eq(%("one two"))
    end

    it "answers array as escaped, quoted string" do
      expect(sanitizer.call([1, :two, "three"])).to eq(%("[1, two, three]"))
    end

    it "answers spaces, tabs, and new lines as escaped, quoted string" do
      expect(sanitizer.call(" \t\n")).to eq(%(" \\t\\n"))
    end

    it "answers control characters as escaped, quoted string" do
      expect(sanitizer.call("\x00-\x1F\x7F")).to eq(%("\\x00-\\x1F\\x7F"))
    end

    it "answers emoji as escaped, quoted string" do
      expect(sanitizer.call("🟢")).to eq(%("\\u{1F7E2}"))
    end

    it "answers multiple types as escaped, quoted string" do
      expect(sanitizer.call("🟢 \x1F \n \t test")).to eq(%("\\u{1F7E2} \\x1F \\n \\t test"))
    end
  end
end
