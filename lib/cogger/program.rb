# frozen_string_literal: true

# Computes default program name based on current file name.
module Cogger
  Program = lambda do |name = $PROGRAM_NAME|
    Pathname(name).then { |path| path.basename(path.extname).to_s }
  end
end
