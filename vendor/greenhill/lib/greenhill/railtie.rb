require 'rails/railtie'

module Greenhill
  class Railtie < Rails::Railtie
    generators do |app|
      require 'rails/generators/rails/model/model_generator'
      Rails::Generators::ModelGenerator.hook_for :admin, type: :boolean, default: true, in: :greenhill
    end
  end
end