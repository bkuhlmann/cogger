# frozen_string_literal: true

require "logger"
require "stringio"

module Cogger
  module Refinements
    # Provides additional enhancements to a logger device.
    module LogDevices
      refine Logger::LogDevice do
        def reread
          case dev
            when File then dev.class.new(dev).read
            when StringIO then dev.tap(&:rewind).read
            else ""
          end
        end
      end
    end
  end
end
