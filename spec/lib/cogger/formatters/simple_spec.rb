# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Simple do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    let(:at) { Time.now }

    it "answers simple string" do
      formatter = described_class.new
      result = formatter.call Cogger::Entry.for("test")

      expect(result).to eq("test\n")
    end

    context "with template using optional attributes" do
      let(:template) { "%<one>s %<two>s %<three>s" }

      it "answers string where leading and trailing spaces are removed" do
        result = formatter.call Cogger::Entry.for(one: nil, two: "Two", three: nil)
        expect(result).to eq("Two\n")
      end
    end

    context "with Rack template" do
      let(:template) { Cogger.get_formatter(:rack).last }

      it "answers detailed string" do
        result = formatter.call Cogger::Entry.for(
          verb: "GET",
          path: "/up",
          duration: "8ms",
          ip: "localhost",
          status: 200,
          length: 50,
          params: {}
        )

        expect(result).to eq("[rspec] [INFO] [#{at}] GET 200 8ms localhost /up 50 {}\n")
      end
    end
  end
end
