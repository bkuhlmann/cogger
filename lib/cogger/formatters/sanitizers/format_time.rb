# frozen_string_literal: true

require "date"

module Cogger
  module Formatters
    module Sanitizers
      # Sanitizes/formats date/time value.
      FormatTime = lambda do |value, format: Cogger::DATETIME_FORMAT|
        return value unless value.is_a?(::Time) || value.is_a?(Date) || value.is_a?(DateTime)

        value.strftime format
      end
    end
  end
end
