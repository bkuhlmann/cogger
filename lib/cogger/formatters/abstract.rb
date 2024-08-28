# frozen_string_literal: true

module Cogger
  module Formatters
    # An abstract class with common/shared functionality.
    class Abstract
      SANITIZERS = {
        datetime: Sanitizers::DateTime,
        escape: Sanitizers::Escape.new,
        filter: Sanitizers::Filter
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
          function = -> value { sanitize_datetime value, format: entry.datetime_format }

          filter attributes
          attributes.transform_values!(&function)
        end
      end

      def escape(...) = sanitizers.fetch(__method__).call(...)

      def filter(...) = sanitizers.fetch(__method__).call(...)

      def sanitize_datetime(...) = sanitizers.fetch(:datetime).call(...)

      private

      attr_reader :sanitizers
    end
  end
end
