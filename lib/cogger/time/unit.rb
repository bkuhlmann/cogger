# frozen_string_literal: true

module Cogger
  module Time
    # Provides unit of measure for duration.
    # rubocop:disable Style/MethodCallWithArgsParentheses
    Unit = lambda do |duration, range: RANGE|
      case duration
        when range.fetch(:nanoseconds) then "ns"
        when range.fetch(:microseconds) then "µs"
        when range.fetch(:milliseconds) then "ms"
        when range.fetch(:seconds) then "s"
        else "m"
      end
    end
    # rubocop:enable Style/MethodCallWithArgsParentheses
  end
end
