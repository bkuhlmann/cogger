# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "json" => "JSON"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Cogger
  extend Registry

  LEVELS = %w[debug info warn error fatal unknown].freeze

  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end

  def self.new(...) = Hub.new(...)
end
