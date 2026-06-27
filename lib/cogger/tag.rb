# frozen_string_literal: true

require "core"
require "refinements/hash"

module Cogger
  # Models a tag which may consist of an array and/or hash.
  Tag = Data.define :singles, :pairs, :exclusions do
    using Refinements::Hash

    def self.for(*bag) = new(**reduce(bag))

    def self.reduce bag
      bag.each.with_object({singles: [], pairs: {}}) do |item, all|
        value = item.is_a?(Proc) ? item.call : item
        value.is_a?(Hash) ? all[:pairs].merge!(value) : all[:singles].append(value)
      end
    end

    private_class_method :reduce

    def initialize singles: [], pairs: {}, exclusions: %w[id level at message]
      filtered_pairs = pairs.reject { |key, _| exclusions.include? key.to_s }

      super singles:, pairs: filtered_pairs, exclusions:
    end

    def empty? = singles.empty? && pairs.empty?

    def to_h
      return Core::EMPTY_HASH if empty?

      singles.empty? ? pairs : {tags: singles.to_a, **pairs}
    end

    def to_s = empty? ? Core::EMPTY_STRING : "#{format_singles} #{format_pairs}".tap(&:strip!)

    private

    def format_singles
      singles.map { |value| "[#{value.inspect}]" }
             .join " "
    end

    def format_pairs
      pairs.map { |key, value| "[#{key}=#{value.inspect}]" }
           .join(" ")
    end
  end
end
