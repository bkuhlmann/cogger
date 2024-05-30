# frozen_string_literal: true

require "core"

module Cogger
  module Formatters
    # Formats as JSON output.
    class Logfmt
      TEMPLATE = nil
      WRAP_STRING_MATCHER = /[[:space:]]|[[:cntrl:]]/

      def initialize template = TEMPLATE,
                     parser: Parsers::Individual.new,
                     sanitizer: Kit::Sanitizer
        @positions = template ? parser.call(template).last.keys : Core::EMPTY_ARRAY
        @sanitizer = sanitizer
      end

      def call(*input)
        attributes = sanitizer.call(*input).tagged_attributes.tap(&:compact!)
        unless positions.empty?
          attributes = attributes.slice(*positions).merge!(attributes.except(*positions))
        end

        "#{attributes.map { |k, v| format_pair(k, v) }.join(" ")}\n"
      end

      private

      attr_reader :positions, :sanitizer

      # :reek:UtilityFunction
      def format_date_time time
        time.utc.strftime "%Y-%m-%dT%H:%M:%S.%L%:z"
      end

      # :reek:UtilityFunction
      def format_pair key, value
        "#{key}=#{format_value value}"
      end

      def format_value value
        case value
          when ::Time
            format_date_time(value)
          when ::Array
            format_value(
              "[#{value.map { |v| format_value(v) }.join(", ")}]"
            )
          else
            # Interpolating for odd cases where #to_s does not return a String:
            # https://github.com/ruby/spec/blob/3affe1e54fcd11918a242ad5d4a7ba895ee30c4c/language/string_spec.rb#L130-L141
            value = "#{value}" # rubocop:disable Style/RedundantInterpolation

            # wrap in quotes and escape control characters
            value = value.dump if value.match? WRAP_STRING_MATCHER
            value
        end
      end
    end
  end
end
