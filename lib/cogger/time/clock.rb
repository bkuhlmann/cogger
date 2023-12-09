# frozen_string_literal: true

module Cogger
  module Time
    # An adapter for acquiring current time.
    Clock = -> id = Process::CLOCK_MONOTONIC, unit: :nanosecond { Process.clock_gettime id, unit }
  end
end
