# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Sanitizers::Filter do
  subject(:sanitizer) { described_class }

  describe "#call" do
    let(:at) { Time.now }

    it "answers filtered values when keys match" do
      Cogger.add_filter :password

      expect(sanitizer.call({login: "test", password: "secret"})).to eq(
        login: "test",
        password: "[FILTERED]"
      )
    end

    it "answers original attributes with nothing to filter" do
      expect(sanitizer.call({message: "test"})).to eq(message: "test")
    end

    it "answers empty attributes when empty" do
      expect(sanitizer.call({})).to eq({})
    end

    it "answers attributes with custom filters" do
      expect(sanitizer.call({one: "test"}, filters: [:one])).to eq(one: "[FILTERED]")
    end

    it "mutates attributes" do
      Cogger.add_filter :password
      attributes = {password: "secret"}

      sanitizer.call attributes

      expect(attributes).to eq(password: "[FILTERED]")
    end
  end
end
