# frozen_string_literal: true

module Cogger
  module Formatters
    module Kit
      # Ensures log entry is filtered of sensitive data.
      Sanitizer = lambda do |*input, filters: Cogger.filters|
        *, entry = input
        entry = Entry.for(entry, severity: "ERROR") unless entry.is_a? Entry
        payload = entry.payload

        filters.each { |key| payload[key] = "[FILTERED]" if payload.key? key }
        entry
      end
    end
  end
end

# TODO: Remove when finished.
__END__

OTHER: ["ERROR", 2024-03-28 19:26:04.052167674 +0000, nil], ENTRY:
