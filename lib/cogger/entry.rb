# frozen_string_literal: true

require "core"

module Cogger
  # Defines a log entry which can be formatted for output.
  Entry = Data.define :id, :severity, :at, :message, :tags, :payload do
    def self.for(message = nil, **payload)
      new id: payload.delete(:id) || Program.call,
          severity: (payload.delete(:severity) || "INFO").upcase,
          message: (block_given? ? yield : message),
          tags: Array(payload.delete(:tags)),
          payload:
    end

    def self.for_crash message, error, id:
      new id:,
          severity: "FATAL",
          message:,
          payload: {
            error_message: error.message,
            error_class: error.class,
            backtrace: error.backtrace
          }
    end

    def initialize id: Program.call,
                   severity: "INFO",
                   at: Time.now,
                   message: nil,
                   tags: [],
                   payload: Core::EMPTY_HASH
      super
    end

    def attributes = {id:, severity:, at:, message:, **payload}

    def tagged_attributes tagger: Tag
      computed_tags = tagger.for(*tags)

      return attributes if computed_tags.empty?

      {id:, severity:, at:, message:, **computed_tags.to_h, **payload}
    end

    def tagged tagger: Tag
      attributes.tap do |pairs|
        computed_tags = tagger.for(*tags)
        pairs[:message] = "#{computed_tags} #{pairs[:message]}" unless computed_tags.empty?
      end
    end
  end
end
