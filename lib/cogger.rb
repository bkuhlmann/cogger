# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "json" => "JSON", "range" => "RANGE"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Cogger
  extend Registry

  DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"
  LEVELS = %w[debug info warn error fatal unknown].freeze

  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end

  def self.new(...) = Hub.new(...)
end
