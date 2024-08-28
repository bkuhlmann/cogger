# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger::Formatters::Abstract do
  subject(:formatter) { described_class.new }

  describe "#call" do
    it "fails when not implemented" do
      expectation = proc { formatter.call }
      expect(&expectation).to raise_error(NoMethodError, /must be implemented/)
    end
  end
end
