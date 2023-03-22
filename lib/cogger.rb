# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

# Main namespace.
module Cogger
  def self.init(...) = Client.new(...)
end
