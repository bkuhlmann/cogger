# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Parsers::Abstract do
  subject(:parser) { described_class.new }

  describe "#call" do
    it "answers template with specific color" do
      expectation = proc { parser.call "" }
      expect(&expectation).to raise_error(NoMethodError, /must be implemented/)
    end
  end
end