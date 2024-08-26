# frozen_string_literal: true

module Cogger
  module Formatters
    module Transformers
      # Transforms directive, based on log level, into a key for color or emoji lookup.
      Key = -> directive, level { (directive == "dynamic" ? level.downcase : directive).to_sym }
    end
  end
end
