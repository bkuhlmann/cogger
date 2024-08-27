# frozen_string_literal: true

RSpec.shared_context "with current time" do
  let(:now) { Time.now }
  let(:at) { now.strftime Cogger::DATETIME_FORMAT }
end
