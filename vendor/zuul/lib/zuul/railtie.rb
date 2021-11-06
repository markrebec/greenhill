require 'rails/railtie'

module Zuul
  class Railtie < Rails::Railtie
    generators do |app|
      # Rails::Generators.configure! app.config.generators
      require_relative '../generators/rails/model_generator'
    end
  end
end