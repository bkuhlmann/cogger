# frozen_string_literal: true

module Cogger
  module Formatters
    module Kit
      # Transform color based on dynamic (level) or standard color preference.
      Colorizer = lambda do |value, attributes|
        value == "dynamic" ? attributes[:level].downcase : value
      end
    end
  end
end
