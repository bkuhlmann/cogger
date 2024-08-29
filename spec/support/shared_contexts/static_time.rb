# frozen_string_literal: true

RSpec.shared_context "with static time" do
  let(:at) { Time.new 2000, 1, 2, 3, 4, 5, "+06:00" }
  let(:at_format) { at.strftime Cogger::DATETIME_FORMAT }
end
