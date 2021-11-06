require 'rails/generators'
require 'rails/generators/rails/model/model_generator'
require 'generators/rails/policy_generator'
require 'generators/rails/type_generator'

module Rails
  module Generators
    class ModelGenerator
      hook_for :policy, type: :boolean, default: true
      hook_for :type, type: :boolean, default: true
    end
  end
end