# frozen_string_literal: true

require "logger"

module Cogger
  module Refinements
    # Provides additional enhancements to a logger.
    module Loggers
      using LogDevices

      refine Logger do
        def reread = @logdev.reread
      end
    end
  end
end
