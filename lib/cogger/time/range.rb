# frozen_string_literal: true

module Cogger
  module Time
    RANGE = {
      nanoseconds: ...1_000,
      microseconds: 1_000...1_000_000,
      milliseconds: 1_000_000...1_000_000_000,
      seconds: 1_000_000_000...60_000_000_000,
      minutes: 60_000_000_000...
    }.freeze
  end
end
