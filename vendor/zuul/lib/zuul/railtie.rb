require 'rails/railtie'

module Zuul
  class Railtie < Rails::Railtie
    generators do |app|
      require 'rails/generators/rails/model/model_generator'
      Rails::Generators::ModelGenerator.hook_for :policy, type: :boolean, default: true, in: :zuul
      Rails::Generators::ModelGenerator.hook_for :type, type: :boolean, default: true, in: :zuul
    end
  end
end