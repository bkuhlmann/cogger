# frozen_string_literal: true

require "core"

module Cogger
  # Defines a log entry which can be formatted for output.
  Entry = Data.define :id, :level, :at, :message, :tags, :datetime_format, :payload do
    def self.for(message = nil, **payload)
      new id: payload.delete(:id) || Program.call,
          level: (payload.delete(:level) || "INFO").upcase,
          at: payload.delete(:at) || ::Time.now,
          message: (block_given? ? yield : message),
          tags: Array(payload.delete(:tags)),
          datetime_format: payload.delete(:datetime_format) || DATETIME_FORMAT,
          payload:
    end

    def self.for_crash message, error, id:
      new id:,
          level: "FATAL",
          message:,
          payload: {
            error_message: error.message,
            error_class: error.class,
            backtrace: error.backtrace
          }
    end

    def initialize id: Program.call,
                   level: "INFO",
                   at: ::Time.now,
                   message: nil,
                   tags: Core::EMPTY_ARRAY,
                   datetime_format: DATETIME_FORMAT,
                   payload: Core::EMPTY_HASH
      super
    end

    def attributes = {id:, level:, at:, message:, **payload}

    def tagged_attributes tagger: Tag
      computed_tags = tagger.for(*tags)

      return attributes if computed_tags.empty?

      {id:, level:, at:, message:, **computed_tags.to_h, **payload}
    end

    def tagged tagger: Tag
      attributes.tap do |pairs|
        computed_tags = tagger.for(*tags)
        pairs[:message] = "#{computed_tags} #{pairs[:message]}" unless computed_tags.empty?
      end
    end
  end
end
