require 'zuul/pundit/object'
require 'zuul/pundit/field'
require 'zuul/pundit/argument'

module Zuul
  module Pundit
    def self.policy_class(klass)
      "#{klass.name.demodulize.gsub(/Type$/, '')}Policy".constantize
    rescue
      nil
    end

    def self.scope_class(klass)
      policy_class(klass)::Scope
    rescue
      nil
    end
  end
end