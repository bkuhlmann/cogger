# frozen_string_literal: true

require "pathname"

# Provides a function for computing the default program name based on current file.
module Cogger
  Program = lambda do |name = $PROGRAM_NAME|
    Pathname(name).then { |path| path.basename(path.extname).to_s }
  end
end
