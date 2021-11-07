# frozen_string_literal: true
require 'rails/generators'
require 'generators/pundit/policy/policy_generator'

module Zuul
  module Generators
    class PolicyGenerator < ::Pundit::Generators::PolicyGenerator
      desc "Generates a Pundit policy for a resource via Zuul"
      source_root ::Pundit::Generators::PolicyGenerator.source_root
    end
  end
end
