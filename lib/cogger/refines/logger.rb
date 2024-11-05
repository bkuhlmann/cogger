# frozen_string_literal: true

module Cogger
  module Refines
    # Provides additional enhancements to a logger.
    module Logger
      using LogDevice

      refine ::Logger do
        def reread = @logdev.reread

        alias_method :any, :unknown
      end
    end
  end
end
