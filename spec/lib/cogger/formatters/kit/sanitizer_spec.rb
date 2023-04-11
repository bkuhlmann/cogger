# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Kit::Sanitizer do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    let(:at) { Time.now }

    it "answers standard hash" do
      expect(sanitizer.call("INFO", at, :test, "test")).to eq(
        id: :test,
        severity: "INFO",
        at:,
        message: "test"
      )
    end

    it "answers expanded hash" do
      expect(sanitizer.call("INFO", at, :test, verb: "GET", path: "/")).to eq(
        id: :test,
        severity: "INFO",
        at:,
        message: nil,
        verb: "GET",
        path: "/"
      )
    end

    it "doesn't override log entry metadata when given duplicate keys" do
      expect(sanitizer.call("INFO", at, :test, id: :bad, severity: :bad, at: :bad)).to eq(
        id: :test,
        severity: "INFO",
        at:,
        message: nil
      )
    end

    it "filters sensitive keys" do
      Cogger.add_filter :password

      expect(sanitizer.call("INFO", at, :test, login: "test", password: "secret")).to eq(
        id: :test,
        severity: "INFO",
        at:,
        message: nil,
        login: "test",
        password: "[FILTERED]"
      )
    end
  end
end
