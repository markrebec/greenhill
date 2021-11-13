module Greenhill
  module Generators
    module CommitHelper
      def self.included(base)
        base.send :class_option, type: :boolean, default: true, desc: "Commit changes in steps along the way"
      end

      def commit(message)
        git add: "."
        git commit: %Q{ -m '#{message.gsub(/'/, "\'")}' }
      end
    end
  end
end