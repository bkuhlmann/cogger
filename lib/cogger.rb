# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.then do |loader|
  loader.inflector.inflect "json" => "JSON"
  loader.setup
end

# Main namespace.
module Cogger
  extend Registry

  def self.init(...) = Client.new(...)

  def self.new(...) = Hub.new(...)
end
