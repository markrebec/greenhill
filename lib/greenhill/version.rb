module Greenhill
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 1
    VERSION = [MAJOR, MINOR, PATCH].join('.')

    class << self
      def inspect
        VERSION
      end
    end
  end
end