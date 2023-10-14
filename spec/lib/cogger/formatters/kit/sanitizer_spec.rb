# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Kit::Sanitizer do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }

    it "answers empty payload by default" do
      entry = sanitizer.call Cogger::Entry.for("test")
      expect(entry).to have_attributes(message: "test", payload: {})
    end

    it "answers custom payload" do
      entry = sanitizer.call Cogger::Entry.for(verb: "GET", path: "/")
      expect(entry).to have_attributes(payload: {verb: "GET", path: "/"})
    end

    it "filters sensitive keys" do
      Cogger.add_filter :password
      entry = sanitizer.call Cogger::Entry.for(login: "test", password: "secret")

      expect(entry).to have_attributes(payload: {login: "test", password: "[FILTERED]"})
    end
  end
end
