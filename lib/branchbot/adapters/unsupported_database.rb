module Branchbot
  module Adapters
    class UnsupportedDatabase < RuntimeError

      attr_reader :adapter

      def initialize(adapter)
        @adapter = adapter
      end

      def message
        "Adapter `#{adapter}` is not supported."
      end

    end
  end
end
