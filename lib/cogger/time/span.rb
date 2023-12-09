# frozen_string_literal: true

module Cogger
  module Time
    # Measures duration of a process with nanosecond precision.
    class Span
      def initialize clock = Clock, unit: Unit, range: RANGE
        @clock = clock
        @unit = unit
        @range = range
      end

      def call
        start = current
        result = yield
        span = current - start

        [result, duration(span), unit.call(span)]
      end

      private

      attr_reader :clock, :unit, :range

      def duration value
        case value
          when nanoseconds then value
          when microseconds then value / microseconds.min
          when milliseconds then value / milliseconds.min
          when seconds then value / seconds.min
          else value / minutes.min
        end
      end

      def current = clock.call

      def nanoseconds
        @nanoseconds ||= range.fetch __method__
      end

      def microseconds
        @microseconds ||= range.fetch __method__
      end

      def milliseconds
        @milliseconds ||= range.fetch __method__
      end

      def seconds
        @seconds ||= range.fetch __method__
      end

      def minutes
        @minutes ||= range.fetch __method__
      end
    end
  end
end
