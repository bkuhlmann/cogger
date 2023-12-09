# frozen_string_literal: true

require "core"

module Cogger
  module Rack
    # Middlware for enriched logging based on the incoming request.
    class Logger
      DEFAULTS = {
        logger: Cogger.new(formatter: :json),
        timer: Cogger::Time::Span.new,
        key_map: {
          verb: "REQUEST_METHOD",
          ip: "REMOTE_ADDR",
          path: "PATH_INFO",
          params: "QUERY_STRING",
          length: "CONTENT_LENGTH"
        }
      }.freeze

      def initialize application, options = Core::EMPTY_HASH, defaults: DEFAULTS
        configuration = defaults.merge options

        @application = application
        @logger = configuration.fetch :logger
        @timer = configuration.fetch :timer
        @key_map = configuration.fetch :key_map
      end

      def call environment
        request = ::Rack::Request.new environment
        (status, headers, body), duration, unit = timer.call { application.call environment }

        logger.info tags: [tags_for(request), {status:, duration:, unit:}]

        [status, headers, body]
      end

      private

      attr_reader :application, :logger, :timer, :key_map

      def tags_for request
        key_map.each_key.with_object({}) do |tag, collection|
          key = key_map.fetch tag, tag
          collection[String(tag).downcase] = request.get_header key
        end
      end
    end
  end
end
