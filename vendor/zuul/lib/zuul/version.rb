module Zuul
  module Version
    MAJOR = 0
    MINOR = 4
    PATCH = 0
    VERSION = [MAJOR, MINOR, PATCH].join('.')

    class << self
      def inspect
        VERSION
      end
    end
  end
end