# frozen_string_literal: true

module Cogger
  module Formatters
    # An abstract class with common/shared functionality.
    class Abstract
      NEW_LINE = "\n"

      SANITIZERS = {
        escape: Sanitizers::Escape.new,
        filter: Sanitizers::Filter,
        format_time: Sanitizers::FormatTime
      }.freeze

      def initialize sanitizers: SANITIZERS
        @sanitizers = sanitizers
      end

      def call(*)
        fail NoMethodError,
             "`#{self.class}##{__method__} #{method(__method__).parameters}` must be implemented."
      end

      protected

      def sanitize entry, message
        entry.public_send(message).tap do |attributes|
          filter attributes
          attributes.transform_values! { |value| format_time value, format: entry.datetime_format }
        end
      end

      def escape(...) = sanitizers.fetch(__method__).call(...)

      def filter(...) = sanitizers.fetch(__method__).call(...)

      def format_time(...) = sanitizers.fetch(__method__).call(...)

      private

      attr_reader :sanitizers
    end
  end
end
