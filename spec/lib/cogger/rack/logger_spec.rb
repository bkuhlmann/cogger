# frozen_string_literal: true

require "rack"
require "spec_helper"

RSpec.describe Cogger::Rack::Logger do
  subject(:middleware) { described_class.new application.new, {logger:} }

  let :application do
    Class.new do
      def initialize body: "test"
        @body = body
      end

      def call(*) = [200, {}, [body]]

      private

      attr_reader :body
    end
  end

  let(:logger) { Cogger.new io: StringIO.new, formatter: :json }

  describe "#call" do
    let(:environment) { Rack::MockRequest.env_for "/" }

    it "answers input as output" do
      expect(middleware.call(environment)).to eq([200, {}, ["test"]])
    end

    it "logs default tags for GET request" do
      environment = Rack::MockRequest.env_for "/", "QUERY_STRING" => {debug: true}
      middleware.call environment

      expect(JSON(logger.reread)).to match(
        hash_including(
          "verb" => "GET",
          "path" => "/",
          "params" => {"debug" => true},
          "status" => 200,
          "duration" => be_a(Integer),
          "unit" => /ns|µs/
        )
      )
    end

    it "logs default tags for POST request" do
      environment = Rack::MockRequest.env_for "/",
                                              "REMOTE_ADDR" => "localhost",
                                              method: "POST",
                                              input: "data"

      middleware.call environment

      expect(JSON(logger.reread)).to match(
        hash_including(
          "ip" => "localhost",
          "verb" => "POST",
          "path" => "/",
          "status" => 200,
          "length" => "4",
          "duration" => be_a(Integer),
          "unit" => /ns|µs/
        )
      )
    end

    it "has no lint issues" do
      linter = Rack::Lint.new middleware
      expectation = proc { linter.call environment }

      expect(&expectation).not_to raise_error
    end
  end
end
