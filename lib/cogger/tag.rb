# frozen_string_literal: true

module Cogger
  # Models a tag which may consist of an array and/or hash.
  Tag = Data.define :singles, :pairs do
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

    def to_a
      return [] if empty?

      pairs.map { |key, value| "#{key}=#{value}" }
           .prepend(*singles.map(&:to_s))
    end

    def to_s = empty? ? "" : "#{format_singles} #{format_pairs}".tap(&:strip!)

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
