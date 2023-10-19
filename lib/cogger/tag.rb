# frozen_string_literal: true

require "core"
require "refinements/hashes"

module Cogger
  # Models a tag which may consist of an array and/or hash.
  Tag = Data.define :singles, :pairs do
    using Refinements::Hashes

    def self.for(*bag)
      bag.each.with_object new do |item, tag|
        value = item.is_a?(Proc) ? item.call : item
        value.is_a?(Hash) ? tag.pairs.merge!(value) : tag.singles.append(value)
      end
    end

    def initialize singles: [], pairs: {}
      super
    end

    def empty? = singles.empty? && pairs.empty?

    def to_h = empty? ? Core::EMPTY_HASH : {tags: singles.to_a, **pairs}.tap(&:compress!)

    def to_s = empty? ? Core::EMPTY_STRING : "#{format_singles} #{format_pairs}".tap(&:strip!)

    private

    def format_singles
      singles.map { |value| "[#{value}]" }
             .join " "
    end

    def format_pairs
      pairs.map { |key, value| "[#{key}=#{value}]" }
           .join(" ")
    end
  end
end
