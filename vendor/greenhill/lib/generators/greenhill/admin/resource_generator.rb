# frozen_string_literal: true
require 'rails/generators'
require 'generators/active_admin/resource/resource_generator'

module Greenhill
  module Admin
    module Generators
      class ResourceGenerator < ActiveAdmin::Generators::ResourceGenerator
        desc "Generates an ActiveAdmin resource via Greenhill"
        source_root ActiveAdmin::Generators::ResourceGenerator.source_root

        class_option :include_boilerplate, type: :boolean, default: true,
                                          desc: "Generate boilerplate code for your resource."

        def generate_config_file
          @boilerplate = Greenhill::Admin::Generators::ResourceGenerator::Boilerplate.new(class_name, args)
          template "admin.rb.erb", "app/admin/#{file_path.tr('/', '_').pluralize}.rb"
        end

        class Boilerplate < ActiveAdmin::Generators::Boilerplate
          def initialize(class_name, attributes)
            @class_name = class_name
            @attributes = attributes.map do |attr|
              name, type = attr.split(':')
              name = "#{name}_id" if type == 'references'
              name
            end
          end

          # normally this would be read from the schema, but we can do a pretty good job
          # by basing it on the provided field arguments and piggybacking on the rest of
          # the admin:resource generator and template.
          def attributes
            @attributes
          end
        end
      end
    end
  end
end
