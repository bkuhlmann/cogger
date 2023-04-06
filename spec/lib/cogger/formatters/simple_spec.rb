# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Simple do
  subject(:formatter) { described_class.new template }

  describe "#call" do
    let(:at) { Time.now }

    it "answers simple string" do
      formatter = described_class.new
      result = formatter.call "INFO", at, :test, "test"

      expect(result).to eq("test\n")
    end

    context "with Rack template" do
      let(:template) { Cogger.get_formatter(:rack).last }

      it "answers detailed string" do
        result = formatter.call "INFO",
                                at,
                                :test,
                                verb: "GET",
                                path: "/up",
                                duration: "8ms",
                                ip: "localhost",
                                status: 200,
                                length: 50,
                                params: {}

        expect(result).to eq("[test] [INFO] [#{at}] GET 200 8ms localhost /up 50 {}\n")
      end
    end
  end
end
