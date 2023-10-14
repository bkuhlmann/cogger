# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cogger do
  describe ".new" do
    it "answers hub instance" do
      expect(described_class.new).to be_a(Cogger::Hub)
    end
  end
end
