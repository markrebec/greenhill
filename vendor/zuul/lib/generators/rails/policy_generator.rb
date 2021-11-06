# frozen_string_literal: true
require 'rails/generators'
require 'generators/pundit/policy/policy_generator'

module Rails
  module Generators
    class PolicyGenerator < ::Pundit::Generators::PolicyGenerator
      source_root ::Pundit::Generators::PolicyGenerator.source_root
    end
  end
end
